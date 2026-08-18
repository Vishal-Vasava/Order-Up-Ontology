// ** Redux Imports
import rootReducer from "./rootReducer"
import { configureStore } from "@reduxjs/toolkit"
import { persistStore } from "redux-persist";
import { loadState, saveState } from "./LocalStorage"
import { persistReducer } from 'redux-persist'
import storage from 'redux-persist/lib/storage'



const persistedState = loadState();
console.log("persistedState ", persistedState);

// const persistedReducer = persistReducer(persistedState, rootReducer);

const persistConfig = {
  key: 'root',
  storage
};

const persistedReducer = persistReducer(persistConfig, rootReducer);

export const store = configureStore({
  reducer: persistedReducer,
  middleware: (getDefaultMiddleware) => {
    return getDefaultMiddleware({
      serializableCheck: false
    })
  }
})

export const persistor = persistStore(store);
