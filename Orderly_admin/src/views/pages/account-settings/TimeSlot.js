import React, { Fragment, useEffect, useState } from "react";
import {
  Button,
  Card,
  CardBody,
  CardHeader,
  CardTitle,
  Col,
  Input,
  Label,
  Row,
} from "reactstrap";
import Flatpickr from "react-flatpickr";
import TextField from "@mui/material/TextField";
import { TimePicker } from "@mui/x-date-pickers/TimePicker";
import { MobileTimePicker } from "@mui/x-date-pickers/MobileTimePicker";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import TimeSlotMain from "./TimeSlotMain";
import axios from "axios";
import { useSelector } from "react-redux";
import { useLocation } from "react-router-dom";
import toast from "react-hot-toast";

const TimeSlot = (props) => {
  const token = localStorage.getItem("token");
  const [data, setData] = useState([]);
  const [allData, setAllData] = useState([]);

  const tour = props.tourData;
  console.log("update timeslot data", data);

  useEffect(() => {
    axios
      .post(
        "/timing/get",
        {
          product_id: tour.id,
        },
        { headers: { Authorization: `Bearer ${token}` } }
      )
      .then((response) => {
        console.log("TimeSlot", response.data.data);
        setData(response.data.data);
        setAllData(response.data.data.time_details);

        // setAllData(response.data.data)
      })
      .catch((err) => {
        console.log(err);
      });
  }, []);

  const addTimeSlot = () => {
    axios
      .post(
        "/timing/update",
        {
          product_id: tour.id,
          product_timing: allData,
        },
        { headers: { Authorization: `Bearer ${token}` } }
      )
      .then((response) => {
        console.log("TimeSlot", response.data.data);
        toast.success(response.data.message);
      })
      .catch((err) => {
        console.log(err);
        toast.error(err.response.data.message);
      });
  };

  return (
    <Fragment>
      <Card>
        <CardBody className="py-2 my-25">
          <Row className="mb-1">
            {data.map((item, index) =>
              item.time_details.map((timing) => (
                <TimeSlotMain
                  index={timing.id}
                  data={timing}
                  day={timing.day}
                  id={timing.id}
                  startTime={timing.startTime}
                  EndTime={timing.EndTime}
                  status={timing.status}
                  setAllData={setAllData}
                  allData={allData}
                />
              ))
            )}
          </Row>

          <Row className="mb-1">
            {/* <Col sm='7' className='mb-1'></Col> */}
            <Col sm="1" className="mb-1">
              <Button color="primary" onClick={addTimeSlot}>
                Save to Draft
              </Button>
            </Col>
          </Row>
        </CardBody>
      </Card>
    </Fragment>
  );
};

export default TimeSlot;
