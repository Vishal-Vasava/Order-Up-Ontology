// ** Reducers Imports
import { combineReducers } from "redux"
import layout from "./layout"
import navbar from "./navbar"
import user from "./user"
import statistic from "./statisticSlice"




// const rootReducer = { navbar, layout, user }

export const rootReducer = combineReducers({ navbar, layout, user,statistic })

export default (rootReducer)
