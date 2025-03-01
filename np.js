const taskInput = document.getElementById('task-input');
const addTaskBtn = document.getElementById('add-task-btn');
const taskList = document.getElementById('task-list');

addTaskBtn.addEventListener('click', () => {
  const task = taskInput.value.trim();
  if (task) {
    const taskListItem = document.createElement('li');
    taskListItem.textContent = task;
    taskList.appendChild(taskListItem);
    taskInput.value = '';
  }
});