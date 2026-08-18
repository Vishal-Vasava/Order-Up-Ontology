const initialState = {
  userData: undefined,
  token: null,
};

const reducer = (state = initialState, action) => {
  switch (action.type) {
    case "ON_SET_USER": {
      return {
        ...state,
        userData: action.payload,
      };
    }
    case "ON_SET_TOKEN": {
      return {
        ...state,
        token: action.payload,
      };
    }
    case "ON_SET_LOGO": {
      return {
        ...state,
        logo: action.payload,
      };
    }
    default:
      return state;
  }
};
export default reducer;
