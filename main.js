// System Meltdown: Game Loop Starter

function gameLoop() {
  console.log("Game loop running...");
  requestAnimationFrame(gameLoop);
}

// Start the loop
gameLoop();
