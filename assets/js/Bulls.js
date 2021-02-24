// /* Bulls & Cows code from HW03, 
// + lecture code from Nat Tuck at https://github.com/NatTuck/scratch-2021-01/tree/master/4550/0209/hangman
// & at https://github.com/NatTuck/scratch-2021-01/blob/master/notes-4550/05-static-deploy/notes.md
// */

import { Container, Row, Col, Form, Table, Button } from 'react-bootstrap';
import React, { useState, useEffect } from 'react';
import { ch_join, ch_push, ch_reset } from './socket';

/* If game meets the requirements of a loss, renders this view */
function GameOver({ reset }) {
  return (
    <Container>
      <Row>
        <Col>
          <h1>Ooph! You lost :( </h1>
          <br />
          <p className="play-again">Try again?</p>
          <div className="btn-holder">
            <Button variant="primary" size="lg" onClick={reset}>
              Reset
            </Button>
          </div>
        </Col>
      </Row>
    </Container>
  );
}

/* If game meets requirements of a win, renders this view */
function GameWon({ reset }) {
  return (
    <Container>
      <Row>
        <Col>
          <h1>Hurray, You Won!</h1>
          <br />
          <p className="play-again">Play again?</p>
          <div className="btn-holder">
            <Button variant="primary" size="lg" onClick={reset}>
              Let's go!
            </Button>
          </div>
        </Col>
      </Row>
    </Container>
  );
}

/*Code for an active game being played */
function Controls({ reset, state }) {
  const [currentGuess, setCurrentGuess] = useState(""); 

  function makeGuess() {
    ch_push({ number: currentGuess });
  }

  /*Function based off Nat Tuck lecture code, with some tweaks to prevent more than 4 numbers */
  function updateGuess(ev) {
    let numericInput = ev.target.value;
    if (numericInput.length > 4) {
      numericInput = numericInput[numericInput.length - 1];;
    }
    setCurrentGuess(numericInput);
  }


  /*Function based off Nat Tuck lecture code, with some tweaks */
  function keyPress(ev) {
    if (ev.key === "Enter") {
      makeGuess();
    }
  }


  function updateGuessHistory(guess, index) {
    return (
      <tr key={index}>
        <td>{index + 1}</td>
        <td>{guess.guess}</td>
        <td>{guess.a} </td>
        <td>{guess.b} </td>
      </tr>
    );
  }

  function generateGuessHistoryTable() {
    return (
      <Row>
        <Col>
          <Table>
            <thead>
              <tr>
                <th>Attempt # (out of 8)</th>
                <th>Guess</th>
                <th>Bulls</th>
                <th>Cows</th>
              </tr>
            </thead>
            <tbody>
              {state.guesses.map((guess, index) => updateGuessHistory(guess, index))}
            </tbody>
          </Table>
        </Col>
      </Row>
    );
  }


  return (
    <Container>
      <Row>
        <Col>
          <h1>Bulls and Cows!</h1>
          <p>(the <em>rootinest,</em> <b>tootinest</b> math game on this here corner of the internet~)</p>
        </Col>
      </Row>
      <Row className="justify-content-md-center">
        <Col xs="4">
          <Form.Label>Guess</Form.Label>
          <Form.Control
            type="number" min="1" max="9"
            value={currentGuess}
            onChange={updateGuess}
            onKeyPress={keyPress}
          />
          <Form.Text>
            Your guess must be exactly 4 unique digits between 0-9, or the guess will not go through!
            </Form.Text>

          <div className="btn-holder">
            <Button variant="primary" size="lg" onClick={makeGuess}>
              Guess
            </Button>
            <div className="btn-holder"></div>
            <Button variant="secondary" size="lg" onClick={() => { reset(); setCurrentGuess(""); }}>
              Reset
            </Button>
          </div>
        </Col>
      </Row>
      {generateGuessHistoryTable()}
    </Container>
  );

}

/*reads the game state and generates view accordingly, refers to Nat tuck lecture code */
function Bulls() {
  const [state, setState] = useState({ //change gameState to state and setState
    guesses: [],
    won: false,
    lost: false,
  });

  useEffect(() => ch_join(setState));

  function reset() {
    ch_reset();
  }

  if (state.won) {
    return (
      <GameWon reset={reset} />
    );
  }
  if (state.lost) {
    return (
      <GameOver reset={reset} />
    );
  }
  return (
    <Controls reset={reset}
      state={state}
      setState={setState} />
  );
}

export default Bulls;