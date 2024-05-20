// CArtAgO artifact code for project app1

package devices;

import cartago.*;

public class SystemController extends Artifact {
	void init() {
		defineObsProperty("systemStatus","on");
	}

	@OPERATION void turnOnSystem() {
		if(!getObsProperty("systemStatus").stringValue().equals("on")){
			System.out.println("Turning on...");
			getObsProperty("systemStatus").updateValue("on");
		}
	}

	@OPERATION void turnOffSystem() {
		if(!getObsProperty("systemStatus").stringValue().equals("off")){
			System.out.println("Turning off...");
			getObsProperty("systemStatus").updateValue("off");
		}
	}

}