# Guess the Bottle Order · 9 Dots Consulting

An 8-bit, Mastermind-style logic game in 9 Dots blue, white and black.

**Play:** https://letrixc.github.io/guess-the-bottle-order/

* 4 bottles are hidden in a secret order (no repeats). Crack it in 10 rounds.
* **Game setting:** 4, 5 or 6 bottle colours, always 4 places.
* ● PERFECT = right colour, right place. ○ COLOUR ONLY = right colour, wrong place.
* **1P Solo**, or **2P Duo Team**:
  * **Create room** gives a 4-digit code (e.g. `0248`); the other player picks **Join room** and enters it. Each player is on their own device. Max 2 players per room; a third is turned away.
  * The room creator chooses who starts. Players take turns; after each guess both screens show the result and switch player. Live picks are visible to the teammate.
  * **Restart** at the end starts a rematch in the same room.
  * **Same device** (pass and play) is still available.
* The result page lists every round, with a comment based on the rounds used (3 = "180 IQ!", 4 = "Holy Crab!", 5 = "Impressive!" … 10 = "At least you made it!", fail = "Nice try, one more time?").
* Share the result card to Teams, by email, copy the text, or save it as a PNG.
* Online rooms use [PeerJS](https://peerjs.com/): the public PeerJS server only introduces the two browsers; game moves then go directly between them (WebRTC). Some strict company networks block this.
* Keyboard: `1`–`6` add bottles, `Backspace` removes the last one, `Enter` confirms.

The whole game is one file, [`index.html`](index.html), served by GitHub Pages.

## Power Apps version

The original Power Apps canvas app (Teams names, online Duo through a SharePoint list) is in [`powerapps/`](powerapps/). See [`powerapps/README.md`](powerapps/README.md).
