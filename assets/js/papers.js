document.addEventListener("DOMContentLoaded", function () {
  const limitSelect = document.getElementById("paperLimit");
  const papersList = document.getElementById("papersList");
  const papers = papersList.getElementsByClassName("paper-card");

  // Function to update visible papers
  function updateVisiblePapers(limit) {
    for (let i = 0; i < papers.length; i++) {
      if (i < limit) {
        papers[i].style.display = "";
      } else {
        papers[i].style.display = "none";
      }
    }
  }

  // Set initial state
  const initialLimit = localStorage.getItem("paperLimit") || 20;
  limitSelect.value = initialLimit;
  updateVisiblePapers(initialLimit);

  // Handle changes
  limitSelect.addEventListener("change", function () {
    const limit = parseInt(this.value);
    localStorage.setItem("paperLimit", limit);
    updateVisiblePapers(limit);
  });
});
