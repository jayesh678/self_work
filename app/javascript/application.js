// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

$(function () {
  var flashDurationInSeconds = 5;
  var flashContainerId = "flash-messages";
  function removeFlashMessages() {
    $("#" + flashContainerId).remove();
  }
  setTimeout(removeFlashMessages, flashDurationInSeconds * 1000);
});

document
  .getElementById("category-filter")
  .addEventListener("change", function () {
    var selectedCategory = this.value;
    var expenseRows = document.querySelectorAll("#expense-table-body tr");

    expenseRows.forEach(function (row) {
      var categoryCell = row.querySelector("td:nth-child(6)");
      var category = categoryCell.textContent.trim();

      if (selectedCategory === "all" || category === selectedCategory) {
        row.style.display = "";
      } else {
        row.style.display = "none";
      }
    });
  });
