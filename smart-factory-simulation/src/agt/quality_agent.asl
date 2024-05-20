orders(0).
results(0).
compliance(0).
nonCompliance(0).

!start.

+!start: 
true <-
  !communicateSettings;
  .wait(15000);
  !communicateSettings;
  .

+!communicateSettings: orders(N) <-
  .send(camera_agent,tell,frontLeftSettings(blue));
  .send(camera_agent,tell,frontRightSettings(blue));
  .send(camera_agent,tell,backLeftSettings(yellow));
  .send(camera_agent,tell,backRightSettings(green));
  -orders(N);
  +orders(N+1);
  .send(camera_agent,tell,order(active));
  .

+compliant(skateboard): compliance(N) & results(R) <-
  -compliance(N);
  +compliance(N+1);
  -results(R);
  +results(R+1);
  .send(camera_agent,untell,order(active));

  .

+nonCompliant(skateboard): nonCompliance(N) & results(R) <-
  -nonCompliance(N);
  +nonCompliance(N+1);
  -results(R);
  +results(R+1);
  .send(camera_agent,untell,order(active));
  .

+active(O) <- .print("Active ",O).

+unfulfilled(O) <- .print("Unfulfilled ",O).

+fulfilled(O) <- .print("Fulfilled ",O).

+sanction(Ag,Sanction)[norm(NormId,Event)]
   <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).

{ include("$jacamo/templates/common-moise.asl") }