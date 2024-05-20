!start.

+!start : true
    <- makeArtifact(nb1,"ora4mas.nopl.NormativeBoard",[],AId);
       focus(AId);
       debug(inspector_gui(on));
       load("src/org/factory.npl");
       makeArtifact(ps1,"police.Sanctioner",[],SArt);
       listen(AId)[artifact_id(SArt)]; // ps1 get normative events (including sanctions) from nb1
       .wait(4000);
       .

+oblUnfulfilled(O) <- .print("Unfulfilled ",O).
+sanction(NormId,Event,Ag,Sanction) <- .print("Sanction ",Sanction," for ",Ag," created from norm ", NormId, " that is ",Event).


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
