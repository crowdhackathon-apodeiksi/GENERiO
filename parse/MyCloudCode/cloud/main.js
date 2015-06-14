function storeReceipt(ccn, seller, cost, vatCost, datetime, num, response) 
{
	var Receipt = Parse.Object.extend("RECEIPTS");
	var receipt = new Receipt();
	receipt.set("CCN", ccn);
	receipt.set("SELLER_ID", seller);
	receipt.set("NUM", num);
	receipt.set("VATCOST", vatCost);
	receipt.set("COST", cost);
	receipt.set("DATETIME", new Date(datetime));
	
	receipt.save(null, {
	  success: function(receipt) {
	    // Execute any logic that should take place after the object is saved.
	    //alert('New object created with objectId: ' + receipt.id);
	    response.success(receipt.id);
	  },
	  error: function(receipt, error) {
	    // Execute any logic that should take place if the save fails.
	    // error is a Parse.Error with an error code and message.
	    response.error('Failed to create new object, with error code: ' + error.message);
	  }
	});
}

function storeBySellerBeforeSave(ccn, customer, seller, cost, vatCost, datetime, num, response) 
{
	var TABLE = Parse.Object.extend("RECEIPTS");
	var query = new Parse.Query(TABLE);
	query.equalTo("CCN", ccn);               
	query.equalTo("SELLER_ID", seller); // SELLER_ID is a Pointer
	query.equalTo("NUM", num);
	query.equalTo("VATCOST", vatCost);
	query.equalTo("COST", cost);
	query.equalTo("DATETIME", new Date(datetime));

	query.find({
	        success: function(results) {

	       	var object = results[0];                        
	       	alert("RES LEN = " + results.length);

	        if (results.length == 1) {

	     		if (customer == undefined) {
					response.error("INVALID RECEIPT. ALREADY EXISTS!");
					return;
				}

	            var possibleCustomer = object.get('CUSTOMER_ID');
	            if (possibleCustomer == undefined) {
	                var receipt = object;
	                receipt.set("CUSTOMER_ID", customer);
	                //receipt.save();
	                //response.success(receipt.id);
	            }
	            else {
	                response.error("INVALID RECEIPT. CUSTOMER EXISTS!");    
	            }

	        }
	        else if (results.length > 1) {
	            response.error("INVALID RECEIPT. More than one results found!");        
	        }
	        else if (results.length == 0) {
	            if (customer == undefined) {
					storeReceipt(ccn, seller, cost, vatCost, datetime, num, response);
					return;
				}
	            response.error("INVALID RECEIPT. No results found!");       
	        }
	    },
	    error: function(error) {

	        if (customer == undefined) {
				storeReceipt(ccn, seller, cost, vatCost, datetime, num, response);
				return;
			}

	        response.error("RECEIPT Error: " + error.code + " " + error.message);
	    }
	});                             
}

function storeBySeller(ccn, customer, sellerVAT, cost, vatCost, datetime, num, response) 
{
    var TABLE = Parse.Object.extend("SELLER");
    var query = new Parse.Query(TABLE);
    query.equalTo("VAT", sellerVAT);

    query.find({
        success: function(results) {
            if (results.length == 1) {
                // SELLER FOUND 
                var object = results[0];
                //response.success("[" + customerId + "]Successfully retrieved " + results.length + " sellers: " + object.get('DESCRIPTION'));
                var seller = object;
                // LETS SEE THE RECEIPTS NOW
                //response.success("[" + sellerId + "]Successfully retrieved " + results.length + " sellers: " + object.get('DESCRIPTION'));

                var TABLE = Parse.Object.extend("RECEIPTS");
                var query = new Parse.Query(TABLE);
                query.equalTo("CCN", ccn);               
                query.equalTo("SELLER_ID", seller); // SELLER_ID is a Pointer
                query.equalTo("NUM", num);
                query.equalTo("VATCOST", vatCost);
                query.equalTo("COST", cost);
                query.equalTo("DATETIME", new Date(datetime));

                query.find({
                        success: function(results) {

                       	var object = results[0];                        
                       	alert(results.length);

                        if (results.length == 1) {

                     		if (customer == undefined) {
								response.error("INVALID RECEIPT. ALREADY EXISTS!");
								return;
							}

                            var possibleCustomer = object.get('CUSTOMER_ID');
                            if (possibleCustomer == undefined) {
                                var receipt = object;
                                receipt.set("CUSTOMER_ID", customer);
                                alert("before save...");
                                receipt.save();
                                alert("after save...");
                                response.success(receipt.id);
                            }
                            else {
                                response.error("INVALID RECEIPT. CUSTOMER EXISTS!");    
                            }

                        }
                        else if (results.length > 1) {
                            response.error("INVALID RECEIPT. More than one results found!");        
                        }
                        else if (results.length == 0) {
                            if (customer == undefined) {
								storeReceipt(ccn, seller, cost, vatCost, datetime, num, response);
								return;
							}
                            response.error("INVALID RECEIPT. No results found!");       
                        }
                    },
                    error: function(error) {

		                if (customer == undefined) {
							storeReceipt(ccn, seller, cost, vatCost, datetime, num, response);
							return;
						}

                        response.error("RECEIPT Error: " + error.code + " " + error.message);
                    }
                });                             


            }
            else if (results.length > 1) {
                response.error("INVALID SELLER VAT. More than one results found!");     
            }
            else if (results.length == 0) {
                response.error("INVALID SELLER VAT. No results found!");        
            }
        },
        error: function(error) {
            response.error("Error: " + error.code + " " + error.message);
        }
    });
}

function storeByCustomer(customerVAT, sellerVAT, cost, vatCost, datetime, num, response) {

    var TABLE = Parse.Object.extend("CUSTOMER");
    var query = new Parse.Query(TABLE);
    query.equalTo("VAT", customerVAT);
 
    query.find({
        success: function(results) {
            if (results.length == 1) {
                // CUSTOMER FOUND 
                var object = results[0];
                var customer = object;              
                //response.success("["+ customerObjectId + "]Successfully retrieved " + results.length + " customers: " + object.get('DESCRIPTION'));
                /*
                for (var i = 0; i < results.length; i++) { 
                  var object = results[i];
                  output = output + (object.id + ' - ' + object.get('KARTA_ID')) + " ";
                }
                response.success("Successfully retrieved " + results.length + " customers: " + output);
                */
 				storeBySeller(0, customer, sellerVAT, cost, vatCost, datetime, num, response); 		
            }
            else if (results.length > 1) {
                response.error("INVALID CUSTOMER VAT. More than one results found!");       
            }
            else if (results.length == 0) {
                response.error("INVALID CUSTOMER VAT. No results found!");      
            }
        },
        error: function(error) {
            response.error("Error: " + error.code + " " + error.message);
        }
    });
}

Parse.Cloud.define("storeReceiptBySeller", function(request, response) {
 	var customerVAT;
    storeBySeller(0, 
    	customerVAT, 
    	request.params.SELLER_VAT,
		request.params.COST, 
        request.params.VATCOST, 
        request.params.DATETIME,
        request.params.NUM,     	 
    	response); 
});

 
Parse.Cloud.define("storeReceiptByCustomer", function(request, response) {
    storeByCustomer(request.params.MY_VAT, 
                  request.params.SELLER_VAT, 
                  request.params.COST, 
                  request.params.VATCOST, 
                  request.params.DATETIME,
                  request.params.NUM,
                  response); 
});

/*
Parse.Cloud.beforeSave("RECEIPTS", function(request, response) {

  if (request.object.get("CUSTOMER_ID") == undefined) {
  	response.success();
  	return;
  }

  var Receipt = Parse.Object.extend("RECEIPTS");
  if (!request.object.get("DATETIME") ||
	  !request.object.get("COST") ||
	  !request.object.get("VATCOST") ||
	  !request.object.get("SELLER_ID")) {
    response.error('You need to provide all the required fields.');
  } 
  else {
    var query = new Parse.Query(Receipt);
    query.equalTo("CCN", 0);
	query.equalTo("DATETIME", request.object.get("DATETIME"));
	query.equalTo("COST", request.object.get("COST"));
	query.equalTo("VATCOST", request.object.get("VATCOST"));
	query.equalTo("SELLER_ID", request.object.get("SELLER_ID"));

    query.first({
      success: function(object) {
        if (object) {
          response.error("RECEIPT ALREADY EXISTS!");
        } else {
          response.success();
        }
      },
      error: function(error) {
        response.error("Could not validate uniqueness for this BusStop object.");
      }
    });
  }
});
*/

/*
Parse.Cloud.beforeSave("RECEIPTS", function(request, response) {
    var receipt = request.object;   
 
 	alert("INSIDE beforeSave");

 	// if beforeSave called from JSON POST requests ignore it
 	//alert("receipt.id = " + receipt.get("LOTTERY_WON"));
    if (receipt.get("LOTTERY_WON") == undefined) {
        response.success();
        return;
    }

	alert("INSIDE REAL beforeSave");

    storeBySellerBeforeSave(0,
      receipt.get("CUSTOMER_ID"), 
	  receipt.get("SELLER_ID"),
      receipt.get("COST"), 
      receipt.get("VATCOST"), 
      receipt.get("DATETIME"),
      receipt.get("NUM"), 
      response);

    response.success(receipt.id);
});
*/

function insertReceipt(ccn, cost, vatcost, num, datetime, seller_vat, response) {
    var Receipt = Parse.Object.extend("RECEIPTS");
    var receipt = new Receipt();
 
    receipt.set("CCN", ccn);
    receipt.set("COST", cost);
    receipt.set("VATCOST", vatcost);
    receipt.set("NUM", num);
    receipt.set("DATETIME", datetime);
    receipt.set("LOTTERY_WON", false);
 
    var TABLE = Parse.Object.extend("SELLER");
    var query = new Parse.Query(TABLE);
    query.equalTo("VAT", seller_vat);
 
    query.find({
        success: function(results) {
            if (results.length == 1) {
                var object = results[0];
                receipt.set("SELLER_ID", object);               
                receipt.save(null, {
                  success: function(receipt) {
                    // Execute any logic that should take place after the object is saved.
                    alert('New object created with objectId: ' + receipt.id);
                  },
                  error: function(receipt, error) {
                    // Execute any logic that should take place if the save fails.
                    // error is a Parse.Error with an error code and message.
                    alert('Failed to create new object, with error code: ' + error.message);
                    //response.error("Error: " + error.code + " " + error.message);
                    return;
                  }
                });
            }
            else if (results.length > 1) {
                response.error("INVALID SELLER. More than one results found!");     
            }
            else if (results.length == 0) {
                response.error("INVALID SELLER. No results found!");        
            }
        },
        error: function(error) {
            response.error("SELLER Error: " + error.code + " " + error.message);
        }
    });
}
 

Parse.Cloud.define("opendata", function(request, response) {
	var TABLE = Parse.Object.extend("RECEIPTS");
    var query = new Parse.Query(TABLE);
 
    query.find({
		success: function(results) {
			var resultsJson = [];
			for (var i = 0; i<results.length; i++) {
			 	var seller = results[i].get("SELLER_ID");
				var resultJson = (results[i].toJSON());
				resultJson["POSTAL_CODE"] = 26443;
				resultsJson.push(resultJson);
			}
			response.success(resultsJson);
		},
		error: function(error) {
            response.error("SELLER Error: " + error.code + " " + error.message);
        }
	 });

});


Parse.Cloud.define("sendReqToTaxis", function(request, response) {

	Parse.Cloud.httpRequest({
	  url: 'http://www.vrisko.gr/afm-etairies/101778030',
	  params: 'q=Sean Plott'
	}).then(function(httpResponse) {
	  console.log(httpResponse.text);
	  response.success(httpResponse.text);
	}, function(httpResponse) {
	  console.error('Request failed with response code ' + httpResponse.status);
	});

});

Parse.Cloud.define("resetReceipt", function(request, response) {
 
   var query = new Parse.Query("RECEIPTS");   
   query.find().then(function (objects) {
       alert("found " + objects.length.toString() + " objects");
       var promises = [];
       objects.forEach(function(obj) {
           alert("ObjectID: " + obj.id.toString() + " deleting");
           promises.push(obj.destroy({
               success: function() {
                   alert("deleted");                  
               },
               error: function() {
                   alert("not deleted");
               }
 
           }));
       });
       return Parse.Promise.when(promises);
   }, function (error) {
       alert("error");
       response.error("error");      
   }).then(function() {
       alert("800426779#000133#2015-06-04T19:13#22.84#2.63#0");
       insertReceipt(0, 22.84, 2.63, 133, new Date("2015-06-04T19:13"), 800426779, response);
       alert("093683423#464627#2015-06-01T07:21#11.06#1.8#0");
       insertReceipt(0, 11.06, 1.8, 464627, new Date("2015-06-01T07:21"), 093683423, response);
       alert("997463748#00066205#2015-06-04T19:44#12.64#1.45#0");
       insertReceipt(0, 12.64, 1.45, 66205, new Date("2015-06-04T19:44"), 997463748, response);
       alert("047823290#08004615#2015-06-04T09:41#1.70#0.31#0");
       insertReceipt(0, 1.70, 0.31, 8004615, new Date("2015-06-04T09:41"), 047823290, response);
       alert("084102623#000018#2015-06-04T10:24#12.40#2.31#0");
       insertReceipt(0, 12.40, 2.31, 18, new Date("2015-06-04T10:24"), 084102623, response);
   });

   //alert("after all!");
   //response.success("Successfully deleted all receipts and inserted hardcoded ones!");

});