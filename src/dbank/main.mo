import Debug "mo:base/Debug";
import Time "mo:base/Time";
import Float "mo:base/Float";

// create a class/actor to hold Cannister
actor DBank {
  stable var currentValue: Float = 300;
  // currentValue := 100; 

  stable var startTime = Time.now();
  // startTime := Time.now();
  Debug.print(debug_show(startTime));

  // Debug.print(debug_show(currentValue));

  // increase the current value in dbank
  public func topUp(amount: Float) {
    currentValue += amount;
    Debug.print(debug_show(currentValue));
  };

  // decrease the current value in dbank
  public func withdraw(amount: Float) {
    let tmpValue: Float = currentValue - amount;
    if (tmpValue >= 0) {
      currentValue -= amount;
      Debug.print(debug_show(currentValue));
    } else {
      Debug.print("Amount too large, current value less than zero");
    }
  };

  // query call: do not modify blockchain; faster to compiler
  public query func checkBalance(): async Float {
    return currentValue;
  };


  // calc compound interest with interest rate of 0.01 and time of second 
  // which means that interest is collected per second 
  public func compound() {
    let currentTime = Time.now();
    let timeElapsedNS = currentTime - startTime;
    let timeElapsedS = timeElapsedNS / 1000000000;

    // update current balance after compounding 
    currentValue := currentValue * (1.01 ** Float.fromInt(timeElapsedS));

    // reset the start time to current to avoid recalucalte the compound interet 
    startTime := currentTime;
  };


}