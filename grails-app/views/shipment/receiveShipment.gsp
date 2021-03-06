
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="layout" content="custom" />
	<g:set var="entityName" value="${warehouse.message(code: 'shipment.label', default: 'Shipment')}" />
	<title><warehouse:message code="shipping.receiveShipment.label"/></title>
</head>

<body>
	<div class="body">
	
		<g:if test="${flash.message}">
			<div class="message">
				${flash.message}
			</div>
		</g:if>
		<g:hasErrors bean="${receiptInstance}">
			<div class="errors">
				<g:renderErrors bean="${receiptInstance}" as="list" />
			</div>
		</g:hasErrors>	

		<div class="dialog">
			
			<g:render template="summary" />
			<g:form action="receiveShipment" method="POST">
				<g:hiddenField name="id" value="${shipmentInstance?.id}" />

                <div class="box">
                    <h2>
                        <img src="${createLinkTo(dir:'images/icons',file:'handtruck.png')}"/>
                        <label><warehouse:message code="receiving.label"/></label>
                    </h2>

                    <table>
                        <tbody>
                        <tr class="prop">
                            <td class="name middle">
                                <label><warehouse:message code="shipping.origin.label" /></label>
                            </td>
                            <td class="value">
                                ${shipmentInstance?.origin?.name }
                            </td>
                        </tr>
                        <tr class="prop">
                            <td class="name middle">
                                <label><warehouse:message code="shipping.destination.label" /></label>
                            </td>
                            <td class="value">
                                ${shipmentInstance?.destination?.name }
                            </td>
                        </tr>

                        <tr class="prop">
                            <td valign="middle" class="name middle">
                                <label><warehouse:message code="shipping.deliveredOn.label"/></label>
                            </td>
                            <td valign="top"
                                class="value ${hasErrors(bean: receiptInstance, field: 'actualDeliveryDate', 'errors')}"
                                nowrap="nowrap">
                                <%--
                                <g:jqueryDatePicker name="actualDeliveryDate"
                                                    value="${receiptInstance?.actualDeliveryDate}" format="MM/dd/yyyy" />
                                --%>
                                <g:datePicker name="actualDeliveryDate" value="${receiptInstance?.actualDeliveryDate}" precision="minute" noSelection="['':'']"/>
                            </td>
                        </tr>
                        <tr class="prop">
                            <td class="name middle">
                                <label><warehouse:message code="shipping.recipient.label" /></label>
                            </td>
                            <td class="value">
                                <g:autoSuggest id="recipient" name="recipient" jsonUrl="${request.contextPath }/json/findPersonByName"
                                       width="300"
                                       styleClass="text"
                                       valueId="${receiptInstance?.recipient?.id}"
                                       valueName="${receiptInstance?.recipient?.name}"/>
                            </td>
                        </tr>
                        <tr class="prop">
                            <td valign="middle" class="name top">
                                <label><warehouse:message code="default.comment.label" /></label>
                            </td>
                            <td valign="top" class="value ${hasErrors(bean: commentInstance, field: 'comment', 'errors')}">
                                <g:textArea name="comment" cols="80" rows="10"/>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="box ${hasErrors(bean: receiptInstance, field: 'receiptItem', 'errors')}">
                    <h2>
                        <label><warehouse:message code="shipping.itemsToReceive.label" default="Items to be received"/></label>
                    </h2>



                    <g:if test="${shipmentInstance?.destination.isWarehouse()}">

                        <g:if test="${!receiptInstance.receiptItems}">
                            <div class="center empty">
                                <warehouse:message code="shipping.noItemsToReceive.label" />
                            </div>
                        </g:if>
                        <g:else>
                            <%--
                            <div>
                                <g:radio name="creditStockOnReceipt" value="no" checked="${params.creditStockOnReceipt=='no' }" />
                                <warehouse:message code="shipping.willNotBeCredited.message"
                                    args="[shipmentInstance?.destination?.name]"/>
                            </div>
                            <div>
                                <g:radio name="creditStockOnReceipt" value="yes" checked="${params.creditStockOnReceipt=='yes' }" />
                                <warehouse:message code="shipping.creditStockOnReceipt.label"
                                    args="[shipmentInstance?.destination?.name]"/>
                            </div>
                            --%>

                                <table>
                                    <thead>
                                        <tr>
                                            <th>${warehouse.message(code:'packingUnit.label', default: 'Packing unit')}</th>
                                            <th class="center"><warehouse:message code="product.productCode.label" /></th>
                                            <th class="left"><warehouse:message code="default.item.label" /></th>
                                            <th style="text-align: center;"><warehouse:message code="default.lotSerialNo.label" /></th>
                                            <th style="text-align: center;"><warehouse:message code="inventoryItem.expirationDate.label" /></th>
                                            <th style="text-align: center;"><warehouse:message code="inventoryLevel.binLocation.label" /></th>
                                            <th style="text-align: center;"><warehouse:message code="shipping.shipped.label" /></th>
                                            <th style="text-align: center;"><warehouse:message code="shipping.received.label" /></th>
                                            <th style="text-align: center;"><warehouse:message code="default.comment.label" /></th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <g:set var="lastContainer"/>
                                        <g:each var="receiptItem" in="${receiptInstance?.receiptItems?.sort() }" status="i">

                                            <g:set var="shipmentItem" value="${receiptItem?.shipmentItem }"/>
                                            <g:set var="inventoryItem" value="${receiptItem?.inventoryItem }"/>
                                            <g:set var="isNewContainer" value="${lastContainer != receiptItem?.shipmentItem?.container }"/>
                                            <tr class="prop ${(i % 2) == 0 ? 'odd' : 'even'} ${lastContainer!=shipmentItem?.container?'top':'' }">
                                                <td style="text-align: left;" class="middle">
                                                    <g:if test="${isNewContainer}">
                                                        <g:render template="container" model="[container:shipmentItem?.container,showDetails:false]"/>
                                                    </g:if>
                                                </td>
                                                <td class="center middle">
                                                    ${receiptItem.product.productCode}

                                                </td>
                                                <td style="text-align: left;" class="middle">
                                                    <g:hiddenField name="receiptItems[${i}].shipmentItem.id" value="${receiptItem?.shipmentItem?.id}"/>
                                                    <g:hiddenField name="receiptItems[${i}].inventoryItem.id" value="${receiptItem?.inventoryItem?.id}"/>
                                                    <g:hiddenField name="receiptItems[${i}].product.id" value="${receiptItem?.product?.id}"/>
                                                    <g:link controller="inventoryItem" action="showStockCard" id="${receiptItem?.product?.id}">
                                                        <format:product product="${receiptItem?.product}"/>
                                                    </g:link>
                                                </td>
                                                <td style="text-align: center;" class="middle">
                                                    <g:hiddenField name="receiptItems[${i}].lotNumber" value="${receiptItem?.lotNumber}"/>
                                                    ${receiptItem?.lotNumber}
                                                </td>
                                                <td style="text-align: center;" class="middle">
                                                    <format:expirationDate obj="${inventoryItem?.expirationDate }"/>
                                                </td>
                                                <td class="center">
                                                    ${shipmentItem?.inventoryItem?.product?.getBinLocation(session.warehouse.id)}
                                                </td>
                                                <td style="text-align: center;" class="middle">
                                                    <g:hiddenField name="receiptItems[${i}].quantityShipped" value="${receiptItem?.quantityShipped}"/>
                                                    ${receiptItem?.quantityShipped}
                                                </td>
                                                <td style="text-align: center;" class="middle">
                                                    <g:textField class="text" name="receiptItems[${i}].quantityReceived" value="${receiptItem?.quantityReceived}" size="3"/>
                                                </td>
                                                <td style="text-align: center;" class="middle">
                                                    <g:textArea class="text" name="receiptItems[${i}].comment" value="${receiptItem?.comment}" cols="40" rows="1"/>
                                                </td>
                                            </tr>

                                            <g:set var="lastContainer" value="${receiptItem?.shipmentItem?.container }"/>

                                        </g:each>
                                    </tbody>
                                </table>
                        </g:else>
                    </g:if>
                </div>


                <div class="buttons center">
                    <button type="submit" class="button icon approve">
                        <warehouse:message code="default.button.save.label" /></button>
                    <g:link controller="shipment" action="showDetails" id="${shipmentInstance?.id}" class="button icon trash">
                        <warehouse:message code="default.button.cancel.label" />
                    </g:link>
                </div>
			</g:form>
    </div>

	<script type="text/javascript">
		$(function() { 		
			/*
			$('#creditStockOnReceipt').click(function() {
			    $("#creditShipmentItems").toggle(this.checked);
			    $("#noCreditShipmentItems").toggle(!this.checked);
			    $("#itemsInShipmentWillBeCredited").toggle(this.checked);
			    $("#itemsInShipmentWillNotBeCredited").toggle(!this.checked);				    
			});
			*/
		});
	</script>
</body>
</html>
