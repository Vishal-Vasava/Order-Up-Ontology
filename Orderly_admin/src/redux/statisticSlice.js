import { createAsyncThunk, createSlice } from "@reduxjs/toolkit";
import axios from "axios";

const sliceName = "statisticSlice";
export const clearDashboardData = createAsyncThunk(
  `${sliceName}/clearDashboardData`,
  async () => {
    try {
      return {
        stististicsCnt: {
          supplier_cnt: 0,
          scan_user_cnt: 0,
          discounted_amt: 0,
          customer_cnt: 0,
          today_scan_user_cnt: 0,
          today_discounted_amt: 0,
          total_supplier_group: [],
          last7DayVisitor: {
            visitorCount: [0, 0, 0, 0, 0, 0, 0],
            totalVisitor: 0,
          },
          last7DayDiscount: {
            month: [
              "Jan",
              "Fab",
              "Mar",
              "Apr",
              "May",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Oct",
              "Nov",
              "Dec",
            ],
            revenue: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            totalRevenu: 0,
            totalOrder: 0,
          },
        },
      };
    } catch (e) {
      return {
        error: e,
        stististicsCnt: {
          supplier_cnt: 0,
          scan_user_cnt: 0,
          discounted_amt: 0,
          customer_cnt: 0,
          today_scan_user_cnt: 0,
          today_discounted_amt: 0,
          total_supplier_group: [],
          last7DayVisitor: {
            visitorCount: [0, 0, 0, 0, 0, 0, 0],
            totalVisitor: 0,
          },
          last7DayDiscount: {
            month: [
              "Jan",
              "Fab",
              "Mar",
              "Apr",
              "May",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Oct",
              "Nov",
              "Dec",
            ],
            revenue: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            totalRevenu: 0,
            totalOrder: 0,
          },
        },
      };
    }
  }
);

export const fetchDashboardData = createAsyncThunk(
  `${sliceName}/fetchDashboardData`,
  async () => {
    try {
      let url = `${process.env.REACT_APP_API_URL}/statistics/dashboard`;
      const token = localStorage.getItem("token");
      const { data } = await axios.post(
        url,
        {},
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );
      return {
        stististicsCnt: data.dashboard,
      };
    } catch (e) {
      return {
        error: e.response.status,
        stististicsCnt: {
          supplier_cnt: 0,
          scan_user_cnt: 0,
          discounted_amt: 0,
          customer_cnt: 0,
          today_scan_user_cnt: 0,
          today_discounted_amt: 0,
          total_supplier_group: [],
          last7DayVisitor: {
            visitorCount: [0, 0, 0, 0, 0, 0, 0],
            totalVisitor: 0,
          },
          last7DayDiscount: {
            month: [
              "Jan",
              "Fab",
              "Mar",
              "Apr",
              "May",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Oct",
              "Nov",
              "Dec",
            ],
            revenue: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            totalRevenu: 0,
            totalOrder: 0,
          },
        },
      };
    }
  }
);
const surveySlice = createSlice({
  name: sliceName,
  initialState: {
    stististicsCnt: {
      supplier_cnt: 0,
      scan_user_cnt: 0,
      discounted_amt: 0,
      customer_cnt: 0,
      today_scan_user_cnt: 0,
      today_discounted_amt: 0,
      total_supplier_group: [],
      last7DayVisitor: {
        visitorCount: [0, 0, 0, 0, 0, 0, 0],
        totalVisitor: 0,
      },
      last7DayDiscount: {
        month: [
          "Jan",
          "Fab",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec",
        ],
        revenue: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        totalRevenu: 0,
        totalOrder: 0,
      },
    },
  },
  extraReducers: {
    [fetchDashboardData.fulfilled]: (state, action) => {
      state.stististicsCounts = action.payload.stististicsCnt;
    },
    [clearDashboardData.fulfilled]: (state, action) => {
      state.stististicsCounts = action.payload.stististicsCnt;
    },
  },
});

export default surveySlice.reducer;
