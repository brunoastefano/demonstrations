/* Initial beliefs and rules */
minimumConfidence(80).

hasForm(AffordanceName, Form) :-
    rdf(Aff, "https://www.w3.org/2019/wot/td#name", AffordanceName) &
    rdf(Aff, "https://www.w3.org/2019/wot/td#hasForm", Form)
  .

hasTarget(Form, Target) :-
    rdf(Form, "https://www.w3.org/2019/wot/hypermedia#hasTarget", Target)
  .

hasOperationType(Form, OpType) :-
    rdf(Form, "https://www.w3.org/2019/wot/hypermedia#hasOperationType", OpType)
  .

+!start :
    true
    <-
    get("http://localhost:8080/td");
    !readAllMeasures ;
  .

+!readAllMeasures :
    true
    <-
    !readProperty("frontLeft");
    !readProperty("frontRight");
    !readProperty("backLeft");
    !readProperty("backRight");
    .

+!readProperty(PropertyName) :
    hasForm(PropertyName, Form) &
    hasTarget(Form, Target) &
    hasOperationType(Form, "https://www.w3.org/2019/wot/td#readProperty")
    <-
    get(Target) ;
    ?(json(Val)[source(Target)]) ;
  .

+json([kv(confidenceMeasure,Confidence),kv(color,Color)])[source(S)] : 
    hasTarget(Form, S) &
    hasForm(PropertyName, Form) &
    PropertyName = "frontLeft"
    <-
    +frontLeftMeasure(Color,Confidence);
    .

+json([kv(confidenceMeasure,Confidence),kv(color,Color)])[source(S)] : 
    hasTarget(Form, S) &
    hasForm(PropertyName, Form) &
    PropertyName = "frontRight"
    <-
    +frontRightMeasure(Color,Confidence);
    .

+json([kv(confidenceMeasure,Confidence),kv(color,Color)])[source(S)] : 
    hasTarget(Form, S) &
    hasForm(PropertyName, Form) &
    PropertyName = "backLeft"
    <-
    +backtLeftMeasure(Color,Confidence);
    .

+json([kv(confidenceMeasure,Confidence),kv(color,Color)])[source(S)] : 
    hasTarget(Form, S) &
    hasForm(PropertyName, Form) &
    PropertyName = "backRight"
    <-
    +backRightMeasure(Color,Confidence);
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