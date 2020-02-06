This project contains the game Master Mind. 

Build a MasterMind game from the command line where you have 12 turns to guess the secret code, starting with you guessing the computer's random code. 

If you've nevered played Mastermind here is a description. 

Description of Master Mind.

The two players decide in advance how many games they will play, which must be an even number. One player becomes the codemaker, the other the codebreaker. The codemaker chooses a pattern of four code pegs. Duplicates and blanks are allowed depending on player choice, so the player could even choose four code pegs of the same color or four blanks. In the instance that blanks are not elected to be a part of the game, the codebreaker may not use blanks in order to establish the final code. The chosen pattern is placed in the four holes covered by the shield, visible to the codemaker but not to the codebreaker.

The codebreaker tries to guess the pattern, in both order and color, within eight to twelve turns. Each guess is made by placing a row of code pegs on the decoding board. Once placed, the codemaker provides feedback by placing from zero to four key pegs in the small holes of the rows within the guess. A colored or black key peg is placed for each code peg from hthe guess which is correct in both color and position. A white key peg indicates the existence of a correct color code peg placed in the wrong position. 

If there are duplicate colors in the guess, they cannot all be awarded a key peg unless they correspond to the same number of duplicated colors in the hidden code. FOr example, if the hidden code is white-white-black-black and the player guesses white-white-white-black, the codemaker will award two colored key pegs for the the two correct whites, nothing for the thrid white as there is not a third white in the code, and a colored key peg for the black. No indication is given of the fact that the code also includes a second black. 

Once feedback is provided, another guess is made; guesses and feedback continue to alternate until either the codebreaker guesses correctly, or twelve incorrect guesses are made. 


