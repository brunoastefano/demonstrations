/* Initial beliefs and rules */
// frontLeftSettings(blue).
// frontRightSettings(blue).
// backLeftSettings(yellow).
// backRightSettings(green).
minimumConfidence(80).
serialPort(ttyUSB0).

/* Initial goals */

!start.

/* Plans */

+!start:
serialPort(Port) <-
	.print("Started Percepting.");
	argo.port(Port);
	argo.percepts(open);
	argo.limit(1000);
	.


+port(Port,Status):
Status = off | Status = timeout <-
	.print("Error communicating with Port = ",Port," || Status = ",Status).

+port(Port,Status):
Status = on <-
	.print("Connected with Port = ",Port," || Status = ",Status).

+ledStatus(on) <-
	.print("Led is On");
	//addFact(ledStatus(on));
	/*argo.act(ledOff);*/
	.

+ledStatus(off) <-
	.print("Led is Off");
	argo.act(ledOn);
	//addFact(ledStatus(off));
	.

+frontLeftMeasure(ColorMeasure,ConfidenceMeasure):
frontLeftSettings(ColorSetting) & minimumConfidence(MinCon) & ColorMeasure == ColorSetting & ConfidenceMeasure > MinCon <-
  +compliant(frontLeft);
	!updateCompliance;
  .  
+frontRightMeasure(ColorMeasure,ConfidenceMeasure):
frontRightSettings(ColorSetting) & minimumConfidence(MinCon) & ColorMeasure == ColorSetting & ConfidenceMeasure > MinCon <-
  +compliant(frontRight);
  !updateCompliance;
  .  
+backLeftMeasure(ColorMeasure,ConfidenceMeasure):
backLeftSettings(ColorSetting) & minimumConfidence(MinCon) & ColorMeasure == ColorSetting & ConfidenceMeasure > MinCon <-
  +compliant(backLeft);
  !updateCompliance;
  .  
+backRightMeasure(ColorMeasure,ConfidenceMeasure):
backRightSettings(ColorSetting) & minimumConfidence(MinCon) & ColorMeasure == ColorSetting & ConfidenceMeasure > MinCon <-
  +compliant(backRight);
  !updateCompliance;
  .

+frontLeftMeasure(ColorMeasure,ConfidenceMeasure):
frontLeftSettings(ColorSetting) & minimumConfidence(MinCon) & (ColorMeasure \== ColorSetting | ConfidenceMeasure <= MinCon) <-
  -compliant(frontLeft);
  !updateCompliance;
  .  
+frontRightMeasure(ColorMeasure,ConfidenceMeasure):
frontRightSettings(ColorSetting) & minimumConfidence(MinCon) & (ColorMeasure \== ColorSetting | ConfidenceMeasure <= MinCon) <-
  -compliant(frontRight);
  !updateCompliance;
  .  
+backLeftMeasure(ColorMeasure,ConfidenceMeasure):
backLeftSettings(ColorSetting) & minimumConfidence(MinCon) & (ColorMeasure \== ColorSetting | ConfidenceMeasure <= MinCon) <-
  -compliant(backLeft);
  !updateCompliance;
  .  
+backRightMeasure(ColorMeasure,ConfidenceMeasure):
backRightSettings(ColorSetting) & minimumConfidence(MinCon) & (ColorMeasure \== ColorSetting | ConfidenceMeasure <= MinCon) <-
  -compliant(backRight);
  !updateCompliance;
  .

+!updateCompliance: compliant(frontLeft) & compliant(frontRight) & compliant(backLeft) & compliant(backRight) <-
	+compliant(skateboard);
  !communicateCompliance;
	.
+!updateCompliance <-
	-compliant(skateboard);
  !communicateNonCompliance;
	.

+!communicateCompliance: order(active) <-
  .send(quality_agent,untell,compliant(skateboard));
  .send(quality_agent,untell,nonCompliant(skateboard));
  .send(quality_agent,tell,compliant(skateboard));
  .

+!communicateCompliance <-
	.print("Compliant!");
	.

+!communicateNonCompliance: order(active) <-
  .send(quality_agent,untell,compliant(skateboard));
  .send(quality_agent,untell,nonCompliant(skateboard));
  .send(quality_agent,tell,nonCompliant(skateboard));
  .

+!communicateNonCompliance <-
	.print("NonCompliant!");
	.

+active(O) <- .print("Active ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+fulfilled(O) <- .print("Fulfilled ",O).

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }