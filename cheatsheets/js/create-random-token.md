# Create A Random Token In JavaScript?


const rand = () => {
  return Math.random().toString(36).substr(2);
};

const token = () => {
  return rand() + rand();
};

console.log(token());



Here is what the above code is doing:
1. We are importing the `Math` module which contains the `random` function.
2. We are invoking the `rand` function and storing the result in the `rand` variable.
3. We are invoking the `rand` function again and storing the result in the `