export const loadState = () => {
  try {
    const serializedState = localStorage.getItem("userData");

    if (serializedState === null) {
      return undefined;
    } else {
      return JSON.parse(serializedState);
    }
  } catch (error) {
    return undefined;
  }
};

export const saveState = (state) => {
  try {
    const serializedState = JSON.stringify(state);
    localStorage.setItem("userData", serializedState);
  } catch (error) {
    console.log("Error in saving state ", error);
  }
};
