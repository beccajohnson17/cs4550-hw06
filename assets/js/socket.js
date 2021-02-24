/*Referred to https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0209/hangman/assets/js/socket.js code */
import { Socket } from "phoenix"

let socket = new Socket(
  "/socket", { params: { token: "" } }
);

socket.connect();

let channel = socket.channel("game:1", {});

let state = {
  guesses: [],
  won: false,
  lost: false,
};

let callback = null;

function state_update(st) {
  state = st;
  if (callback) {
    callback(st);
  }
}

export function ch_join(cb) {
  callback = cb;
  callback(state);
}


export function ch_push(guess) {
  channel.push("guess", guess)
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to push", resp)
         });
}

export function ch_reset() {
  channel.push("reset", {})
         .receive("ok", state_update)
         .receive("error", resp => {
           console.log("Unable to push", resp)
         });
}

channel.join()
  .receive("ok", state_update)
  .receive("error", resp => {
    console.log("Unable to join", resp)
  });

export default socket
