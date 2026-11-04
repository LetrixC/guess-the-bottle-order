# Guess the Bottle Order · 9 Dots Consulting

An 8-bit Power Apps canvas game in blue, white and black. You play it like Mastermind, but with coloured bottles.

* **Rules:** the system hides 4 bottles. There are 6 colours and none repeat. You get 10 turns.
* **Clues after each guess:** ● **PERFECT** means the right colour in the right slot. ○ **COLOUR ONLY** means the right colour in the wrong slot.
* **1P Solo:** you play alone, and the game counts your turns.
* **2P Duo Team:** you team up with a colleague picked by their Teams account. You take turns and must not talk. A hand-off screen between turns says "pass the device, no talking". The game counts turns for the team and for each player.
* **Result page:** shows a pixel result card with the players' **Teams account names**, the turns used and the secret code. You can share it to Teams, send it in a Teams chat to a colleague, send it by email, or copy it.

## Files

| File | Paste into |
|---|---|
| `01-App.Formulas.pfx` | **App → Formulas** (colours, bottles, pixel art) |
| `02-scrHome.yaml` | screen `scrHome` |
| `03-scrTeam.yaml` | screen `scrTeam` |
| `04-scrGame.yaml` | screen `scrGame` |
| `05-scrResult.yaml` | screen `scrResult` |

## Build it (about 10 minutes)

1. Go to **make.powerapps.com**, then **Create → Blank canvas app**, and choose the **Tablet** format (1366 × 768).
2. **Data → Add data → Office 365 Users**. This is used to pick a teammate or friend by Teams name.
3. In the Tree view, select **App**. Choose the **Formulas** property and paste all of `01-App.Formulas.pfx`.
4. Rename `Screen1` to **scrHome**. Then add 3 blank screens and name them **scrTeam**, **scrGame** and **scrResult**. Create all four before you paste anything, because the screens point to each other.
5. Set these screen properties:
   * All 4 screens: `Fill` = `C_Black`
   * **scrGame**, `OnVisible`: paste the following. It starts a new game every time the screen opens.

     ```
     With({s: FirstN(Shuffle(Bottles), 4)},
         Set(gC1, Index(s, 1).Id); Set(gC2, Index(s, 2).Id);
         Set(gC3, Index(s, 3).Id); Set(gC4, Index(s, 4).Id)
     );
     Clear(colHistory);
     Set(gTurn, 1); Set(gSeat, 1); Set(gWin, false);
     UpdateContext({locS1: 0, locS2: 0, locS3: 0, locS4: 0, locHandoff: gMode = "DUO"})
     ```
6. For each screen, open its `.yaml` file and copy everything. In the Tree view, right-click the screen, choose **Paste**, or select the screen and press Ctrl+V.
7. Press F5 to play.
8. Publish. Copy the app's **web link** from **Details**, and put it in `AppPlayLink` in App → Formulas so that shared messages link back to the game. To use the app inside Teams, choose **Publish → Add to Teams**.

## Online Duo (each player on their own computer)

* **Shared game list:** **BottleGames**, on `https://9d.sharepoint.com/sites/9DotsGLOBAL-9Dots-HK`. A shortcut to it is in *ERP Team › 9Dots › 06 Functions*.
* **Columns:** RoomCode, HostName, HostEmail, GuestName, GuestEmail, TeamName, Secret (`3,1,5,2`), Status (`WAITING` / `PLAYING` / `WON` / `LOST` / `QUIT` / `CANCELLED`), Turn, Seat, and Guesses (`turn|seat|s1|s2|s3|s4|perfect|colour;`).
* **Hosting:** 2P DUO TEAM → pick a teammate → **ONLINE ROOM ▶**. This creates a row and shows a 4-letter code.
* **Joining:** on the guest's computer, 2P DUO TEAM → **JOIN A ROOM**. The invite is picked up automatically, or the guest types the code.
* **Syncing:** a timer on scrLobby and scrGame refreshes the list every 2 seconds. Only the player whose turn it is can move.
* **Permissions:** players need edit rights on the BottleGames list. Members of the 9Dots HK site have them already. For anyone else, share the list with them.
* **Re-pasting screens:** run `build-paste.ps1 -UsersConnector <name>` to rebuild `00-Paste-Online.yaml`, using the Office 365 Users name your Studio shows.

## Customising

* **9Dots colours:** change `C_Blue`, `C_Navy` and the other colour values at the top of App → Formulas.
* **Number of turns:** change `MaxTurns`.
* **Bottle colours:** change the `Bottles` table. Keep 6 rows with Ids 1–6.

## Troubleshooting

* **The background covers everything:** select `imgBg…` and choose **Reorder → Send to back**.
* **Formula errors with `,` or `;`:** your Studio uses a European locale. In that case, use `;` for separators and `;;` for chaining.
* **The teammate search is empty:** check that the **Office 365 Users** connection was added (step 2). Also check that `DisplayFields` and `SearchFields` on `cmbMate` and `cmbFriend` are still `["DisplayName"]`. Studio resets them to `["City"]` whenever `Items` is edited.
* **`'SearchUser' is unknown in namespace 'Office365Users'`:** in a non-English Studio, the connector has a local name. In Traditional Chinese, for example, it's `Office365使用者`. Use that name in the `Items` formula of both search boxes.
* **Fonts:** Courier New Bold is used for the 8-bit look, because canvas apps can't load web pixel fonts. All pixel art (bottles, 9-dot logo, result card) is drawn as SVG, so it stays crisp.
