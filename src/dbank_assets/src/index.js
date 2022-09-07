import { UpdateCallRejectedError } from "@dfinity/agent";
import { dbank } from "../../declarations/dbank";

// update current balance in bank when page is loaded
window.addEventListener("load", async function() {
    // console.log("page loaded");
    update();
});

// increase balance by input amount
document.querySelector("form").addEventListener("submit", async function(event) {
    event.preventDefault();    // prevent auto-fresh due to property of form

    const button = event.target.querySelector("#submit-btn");
    const inputAmount = parseFloat(document.getElementById("input-amount").value);
    const outputAmount = parseFloat(document.getElementById("withdrawal-amount").value);

    // disable the submit button while waiting to increase balance
    button.setAttribute("disabled", true);

    if (document.getElementById("input-amount").value.length != 0) {
        await dbank.topUp(inputAmount);
    }

    if (document.getElementById("withdrawal-amount").value.length != 0) {
        await dbank.withdraw(outputAmount);
    }

    await dbank.compound();

    // show update balance on window
    update();
   
    // clear input/withdraw area afterward
    document.getElementById("input-amount").value = "";
    document.getElementById("withdrawal-amount").value = "";

    // reset the submit button to work
    button.removeAttribute("disabled");
});

// update the current balance in bank 
async function update() {
    const currentValue = await dbank.checkBalance();
    document.getElementById("value").innerText = Math.round(currentValue * 100) / 100;
}