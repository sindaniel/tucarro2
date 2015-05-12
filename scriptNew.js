var agi = require('agi');
var net = require('net');

var config = {};
config.port = "60004";
config.host = "127.0.0.1";

var callerStatus = {};

var DEBUG = true;

agi.createServer(function(context) {
  context.on("variables", function(vars) {
    context.exec("ANSWER", function(err, res) {
      var auxUniqueID = vars.agi_uniqueid;

      console.log(vars)
      
      callerStatus[auxUniqueID] = {};
      callerStatus[auxUniqueID].status = false;
      callerStatus[auxUniqueID].socket = net.createConnection(config.port, config.host);

      callerStatus[auxUniqueID].socket.on("data", function (data) {
        data = "" + data;
        try {
          data = JSON.parse(data);
        } catch (err) {
          data = {};
        }

        if (DEBUG) {
          console.log("*** Data from Eleinco ***");
          console.log(data);
          console.log("*** ### ***");
        }

        switch (data.command) {
          case "CallerIDJob":
            if (data.data.Status == "Failure") {
              console.log("Error durante el CallerIDJob: " + data.data.FailureReason);
              command = {command: "Quit", data: data.data, operadora: true};
              callerStatus[auxUniqueID].socket.write(JSON.stringify(command));
              break;
            }

            callerStatus[auxUniqueID].newAddress = "";
            callerStatus[auxUniqueID].readableAddress = "";
            
            console.log(data);

           
            callerStatus[auxUniqueID].strMenuPrincipal = buildIVR();
            context.exec("Background", callerStatus[auxUniqueID].strMenuPrincipal, function(err, res) {
              if (err) return -1;
              if (res.result != 0 && res.result != -1) digit = res.result - 48; else digit = Number(res.result);

              switch (digit) {
                case -1:
                  console.log("COLGARON");
                  command = {command: "Quit", data: data.data, operadora: false};
                  callerStatus[auxUniqueID].socket.write(JSON.stringify(command));
                  break;
                
                case 1:
                  console.log("INGRESA POR BOOKING");
                  command = {command: "BookingRequest", data: data.data};
                  callerStatus[auxUniqueID].socket.write(JSON.stringify(command));
                  
                  context.exec("MusicOnHold", "Eleinco,3", function(err, res) {
                    if (res.result == "-1") {
                      command = {command: "Hangup", data: data.data, JobBooked: true, HangupStatus: "UserHangup"};
                      callerStatus[auxUniqueID].socket.write(JSON.stringify(command));
                    }
                  });
                  var waitInterval = setInterval(function() {
                    if (callerStatus[data.data.MessageID] != undefined && !callerStatus[data.data.MessageID].status) {
                      context.exec("MusicOnHold", "Eleinco,3", function(err, res) {
                        if (res.result == "-1") {
                          try {
                            command = {command: "Hangup", data: data.data, JobBooked: true, HangupStatus: "UserHangup"};
                            callerStatus[auxUniqueID].socket.write(JSON.stringify(command));
                          } catch (err) {
                            console.log("COLGARON - NO SE PUDO ENVIAR HANGUP");
                            callerStatus[auxUniqueID].socket.end();
                            callerStatus[auxUniqueID].socket.destroy();
                            delete callerStatus[auxUniqueID];
                            context.end();
                          }
                        }
                      });
                    
                    } else if (callerStatus[data.data.MessageID] != undefined) {
                      console.log("SE DETIENE MOH");
                      clearInterval(waitInterval);
                      if (callerStatus[data.data.MessageID].state == "Dispatched") {
                        _auxCallerID = callerStatus[data.data.MessageID].CallerID;
                        _auxVehReg = callerStatus[data.data.MessageID].VehReg;
                        _ETA = callerStatus[data.data.MessageID].ETA;
                        _auxVehCallsign = callerStatus[data.data.MessageID].Vehicle;

                        console.log("SERVICIO DESPACHADO - " + _auxCallerID + " - " + _auxVehReg + ".");


                        
                        callerStatus[auxUniqueID].strDispatched = dispatchedMessage(_auxCallerID, _auxVehReg, _ETA, _auxVehCallsign) +  "";
                        console.log(callerStatus[auxUniqueID].strDispatched);

                               console.log( callerStatus[auxUniqueID].strDispatched);
                       

                          context.exec("Background", callerStatus[auxUniqueID].strDispatched, function(err, res) {
                                  
                                  console.log(res.result)
                                  
                                    console.log('Confirmo por que no ha colgado')
                                    try {
                                      command = {command: "Hangup", data: data.data, JobBooked: true, HangupStatus: "SystemHangup"};
                                      callerStatus[auxUniqueID].socket.write(JSON.stringify(command));
                                    } catch (err) {
                                      console.log("SE REPRODUJO - NO SE PUDO ENVIAR HANGUP");
                                      callerStatus[auxUniqueID].socket.end();
                                      callerStatus[auxUniqueID].socket.destroy();
                                      delete callerStatus[auxUniqueID];
                                      context.end();
                                    }
                                  


                                context.exec("Background", callerStatus[auxUniqueID].strDispatched.message+'&ivr/taxi/un-placer-servirle', function(err, res) {
                                    console.log('Termino de confirmar')
                                });
                                  
                        });





                                 



                      
                        
                      } else if (callerStatus[data.data.MessageID].state == "Cancelled") {
                        _auxCallerID = callerStatus[data.data.MessageID].CallerID;
                        console.log("SERVICIO CANCELADO - " + _auxCallerID + ".");

                        callerStatus[auxUniqueID].strCancelled = cancelledMessage() +  "";
                        console.log(callerStatus[auxUniqueID].strCancelled);
                        context.exec("Background", callerStatus[auxUniqueID].strCancelled, function(err, res) {
                          if (err) console.log(err);
                          if (res.result == "-1") {
                            try {
                              command = {command: " ", data: data.data, JobBooked: true, HangupStatus: "UserHangup"};
                              callerStatus[auxUniqueID].socket.write(JSON.stringify(command));
                            } catch (err) {
                              console.log("COLGARON - NO SE PUDO ENVIAR HANGUP");
                              callerStatus[auxUniqueID].socket.end();
                              callerStatus[auxUniqueID].socket.destroy();
                              delete callerStatus[auxUniqueID];
                              context.end();
                            }
                          } else if (res.result == "0") {
                            try {
                              command = {command: "Hangup", data: data.data, JobBooked: true, HangupStatus: "SystemHangup"};
                              callerStatus[auxUniqueID].socket.write(JSON.stringify(command));
                            } catch (err) {
                              console.log("SE REPRODUJO - NO SE PUDO ENVIAR HANGUP");
                              callerStatus[auxUniqueID].socket.end();
                              callerStatus[auxUniqueID].socket.destroy();
                              delete callerStatus[auxUniqueID];
                              context.end();
                            }
                          }
                        });
                      } else if (callerStatus[data.data.MessageID].state == "Invalid") {
                        _auxCallerID = callerStatus[data.data.MessageID].CallerID;
                        console.log("SERVICIO INVALID - " + _auxCallerID + ".");
                        command = {command: "Quit", data: data.data, operadora: true, systemHangup: true};
                        callerStatus[auxUniqueID].socket.write(JSON.stringify(command));

                      } else {
                        console.log("NI DESPACHADO NI CANCELADO");
                        console.log("ENVIADO A OPERADORA");
                        command = {command: "Quit", data: data.data, operadora: true};
                        callerStatus[auxUniqueID].socket.write(JSON.stringify(command));
                      }
                    } else {
                      clearInterval(waitInterval);
                    }
                  }, 3000);
                  break;

                default:
                  console.log("INGRESA POR EXTRAS");
                  command = {command: "Quit", data: data.data, operadora: true};
                  callerStatus[auxUniqueID].socket.write(JSON.stringify(command));
                  break;
              }
            });
            break;

          case "JobDispatched":
            callerStatus[auxUniqueID].data = data.data;
            callerStatus[auxUniqueID].CallerID = data.data.PhoneNumber;
            callerStatus[auxUniqueID].VehReg = data.data.VehReg;
            callerStatus[auxUniqueID].ETA = data.data.ETA;
            callerStatus[auxUniqueID].Vehicle = data.data.Vehicle;
            callerStatus[auxUniqueID].state = "Dispatched";
            callerStatus[auxUniqueID].status = true;
            break;

          case "JobCancelled":
            callerStatus[auxUniqueID].data = data.data;
            callerStatus[auxUniqueID].CallerID = data.data.PhoneNumber;
            callerStatus[auxUniqueID].state = "Cancelled";
            callerStatus[auxUniqueID].status = true;
            break;

          case "JobInvalid":
            callerStatus[auxUniqueID].data = data.data;
            callerStatus[auxUniqueID].CallerID = data.data.PhoneNumber;
            callerStatus[auxUniqueID].state = "Invalid";
            callerStatus[auxUniqueID].status = true;
            break;

          case "Quit":
            callerStatus[auxUniqueID].status = true;
            if (data.operadora) {
              context.exec("SET", "operadora=1", function (err, res) {
                callerStatus[auxUniqueID].socket.end();
                callerStatus[auxUniqueID].socket.destroy();
                delete callerStatus[auxUniqueID];
                context.end();
              });
            } else {
              callerStatus[auxUniqueID].socket.end();
              callerStatus[auxUniqueID].socket.destroy();
              delete callerStatus[auxUniqueID];
              context.end();
            }
            break;
        }
      });

      callerStatus[auxUniqueID].socket.on("close", function() {
        context.end();
      });

      callerStatus[auxUniqueID].socket.on("connect", function() {
        command = {command: "CallerIDJob", data: {uniqueID: vars.agi_uniqueid, callerID: vars.agi_callerid}};
        callerStatus[auxUniqueID].socket.write(JSON.stringify(command));
      });

      callerStatus[auxUniqueID].socket.on("error", function(err) {
        console.log(err);
      });
    });
  });
  
  context.on('error', function (err) {
    console.log(err);
    context.end();
  });

}).listen(60005);

function buildIVR() {
  var ivr = "";

  //ivr += addressStreams;

  ivr += "ivr/taxi/para-servicio-automatico-de-taxi-marque-1";
  //ivr += "&ivr/taxi/para-servicio-de-taxi-con-vale-marque-2";
  //ivr += "&ivr/taxi/para-otros-servicios-marque-3";
  ivr += "&ivr/taxi/comunicarse-con-una-operadora";
  ivr += "&ivr/taxi/vacio";

  return ivr;
}

function addressToStreams(address) {
  addressStreams = "ivr/taxi/su-direccion-es";
  addressParts = address.match(/[\w]*/g);
  console.log(addressParts);

  for (var i = 0; i < addressParts.length; i++) {

    if (i == 3) {
      addressStreams += "&ivr/address/con";
      continue;
    }

    if (addressParts[i] === "") { continue; }
    
    if (/^[0-9]+$/g.test(addressParts[i])) { //Numeric
      console.log("Number: " + addressParts[i]);
      addressStreams = numericAddress(addressParts[i]);

    } else if (/^[a-zA-Z]+$/.test(addressParts[i])) { // Alpha
      console.log("Alpha: " + addressParts[i]);
      addressStreams += "&ivr/address/" + addressParts[i].toLowerCase();

    } else if (/[\w]*/g.test(addressParts[i])) { // AlphaNumeric
      console.log("Alphanumeric: " + addressParts[i]);
      parts = addressParts[i].match(/(\d+|[\D]+)/g);

      console.log(parts);

      for (var k = 0; k < parts.length; k++) {
        if (/^[a-zA-Z]+$/.test(parts[k])) { // The alpha part
          addressStreams = letterAddress(parts[k]);
        } else { //Numeric
          addressStreams = numericAddress(parts[k]);
        }
      }
    }
  }

  if (DEBUG) {
    console.log("*** Address to Streams ***");
    console.log(addressStreams.split("&"));
    console.log("*** ### ***");
  }

  return addressStreams;

  function numericAddress(addressPart) {
    if (Number(addressPart) <= 20) {
      addressStreams += "&ivr/numbers/" + Number(addressPart);

    } else if (Number(addressPart) >= 21 && Number(addressPart) <= 29) {
      digits = addressPart.split("");
      addressStreams += "&ivr/numbers/veinti";
      addressStreams += "&ivr/numbers/" + digits[1];

    } else if (Number(addressPart) >= 101 && Number(addressPart) <= 199) {
      digits = addressPart.split("");
      ten = Number(digits[1] + digits[2]);

      addressStreams += "&ivr/numbers/ciento";

      if (ten <= 20) {
        addressStreams += "&ivr/numbers/" + ten;

      } else if (ten >= 21 && ten <= 29) {
        addressStreams += "&ivr/numbers/veinti";
        addressStreams += "&ivr/numbers/" + digits[2];

      } else if (ten % 10 == 0) {
        addressStreams += "&ivr/numbers/" + ten;

      } else {
        addressStreams += "&ivr/numbers/" + digits[1] + "0";
        addressStreams += "&ivr/numbers/y";
        addressStreams += "&ivr/numbers/" + digits[2];
      }

    } else if (Number(addressPart) % 10 == 0) {
      addressStreams += "&ivr/numbers/" + Number(addressPart);

    } else {
      digits = addressPart.split("");
      for (var j = 0; j < digits.length; j++) {
        if (digits.length >= 2) {
          if (digits.length >= 2 && j + 1 == digits.length) {
            addressStreams += "&ivr/numbers/y";
          }
        }
        if (Number(digits[j] != 0)) {
          addressStreams += "&ivr/numbers/" + digits[j] + (Array(digits.length - j).join("0"));
        }
      }
    }
    return addressStreams;
  }

  function letterAddress(letters) {
    letters = parts[k].split("");
    console.log("Letters: " + letters);
    for (var w = 0; w < letters.length; w++) {
      if (letters[w].toLowerCase() == 's') {
        addressStreams += "&ivr/phonetic/sur";
      } else {
        addressStreams += "&ivr/phonetic/" + letters[w].toLowerCase();
      }
    }
    return addressStreams;
  }
}

function phoneToStreams (phoneNumber) {
  var msg = "";
  for (var i in phoneNumber) {
    if (i == 0) {
      msg += "ivr/numbers/" + phoneNumber[i];
    } else {
      msg += "&ivr/numbers/" + phoneNumber[i];
    }
  }

  return msg;
}

function dispatchedMessage(phoneNumber, vehicleRegistration, ETA, vehicleCallsign) {


  console.log('******* LLEGA *******')
  console.log(phoneNumber)
  console.log('**************')
  console.log(vehicleRegistration)
  console.log('**************')
  console.log(ETA)
  console.log('**************')
  console.log(vehicleCallsign)
  console.log('******* FIN *******')



  var dispatchedMessage = "ivr/taxi/codigo-de-seguridad";
  phoneNumber = phoneNumber + "";
  securityCode = phoneNumber.substring(phoneNumber.length - 2);

  ETA = ETA + "";
  vehicleCallsign = vehicleCallsign + "";

  if (Number(securityCode) >= 0 && Number(securityCode) <= 9) {
    dispatchedMessage += "&ivr/numbers/0" + "&ivr/numbers/" + Number(securityCode);

  } else if (Number(securityCode) <= 20) {
    dispatchedMessage += "&ivr/numbers/" + Number(securityCode);
  
  } else if (Number(securityCode) >= 21 && Number(securityCode) <= 29) {
    digits = securityCode.split("");
    dispatchedMessage += "&ivr/numbers/veinti";
    dispatchedMessage += "&ivr/numbers/" + digits[1];

  } else if (Number(securityCode) % 10 == 0) {
    dispatchedMessage += "&ivr/numbers/" + Number(securityCode);
 
  } else {
    digits = securityCode.split("");
    for (var j = 0; j < digits.length; j++) {
      if (digits.length >= 2 && j + 1 == digits.length) {
        dispatchedMessage += "&ivr/numbers/y";
      }
      dispatchedMessage += "&ivr/numbers/" + digits[j] + (Array(digits.length - j).join("0"));
    }
  }

  dispatchedMessage += "&ivr/taxi/el-vehiculo-placa";
  parts = vehicleRegistration.split("");
  for (var j = 0; j < parts.length; j++) {
    if (/[a-zA-Z]/.test(parts[j])) {
      dispatchedMessage += "&ivr/letters/" + parts[j].toLowerCase();
    } else if (/[0-9]/.test(parts[j])) {
      dispatchedMessage += "&ivr/numbers/" + parts[j];
    }
  }

  dispatchedMessage += "&ivr/taxi/el-numero-del-movil-es";
  parts = vehicleCallsign.split("");
  for (var j = 0; j < parts.length; j++) {
    dispatchedMessage += "&ivr/numbers/" + parts[j];
  }

if (Number(ETA) <= 20) {
    dispatchedMessage += "&ivr/taxi/llegara-en&ivr/numbers/"+Number(ETA)+"&ivr/taxi/minutos";
  
  } else if (Number(ETA) >= 21 && Number(ETA) <= 29) {
    digits = ETA.split("");
    dispatchedMessage += "&ivr/taxi/llegara-en&ivr/numbers/veinti&ivr/numbers/" + digits[1] + "&ivr/taxi/minutos";

  } else if (Number(ETA) % 10 == 0) {
    dispatchedMessage += "&ivr/taxi/llegara-en&ivr/numbers/"+Number(ETA)+"&ivr/taxi/minutos";
 
  } else {
    digits = ETA.split("");
    for (var j = 0; j < digits.length; j++) {
      if (digits.length >= 2 && j + 1 == digits.length) {
        dispatchedMessage += "&ivr/numbers/y";
      }
      dispatchedMessage += "&ivr/numbers/" + digits[j] + (Array(digits.length - j).join("0"));
    }
  }




  //dispatchedMessage += "&" + dispatchedMessage + "&ivr/taxi/un-placer-servirle";




      // dispatchedMessages = {};
      // dispatchedMessages.message = dispatchedMessage;
      // dispatchedMessages.farewell = 

     // console.log(dispatchedMessages)



  return dispatchedMessage;
}

function cancelledMessage() {
  var cancelledMessage = "ivr/taxi/no-hay-movil-2";
  return cancelledMessage;
}


