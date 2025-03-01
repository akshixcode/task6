document.getElementById('student-form').addEventListener('submit', function(e) {
  e.preventDefault();
  
  const name = document.getElementById('name').value;
  const grade = document.getElementById('grade').value;
  const progress = document.getElementById('progress').value;
  
  addRecord(name, grade, progress);
  
  document.getElementById('student-form').reset();
});

function addRecord(name, grade, progress) {
  const tableBody = document.getElementById('records-table').querySelector('tbody');
  const newRow = document.createElement('tr');
  
  newRow.innerHTML = `
      <td>${name}</td>
      <td>${grade}</td>
      <td>${progress}</td>
  `;
  
  tableBody.appendChild(newRow);
}