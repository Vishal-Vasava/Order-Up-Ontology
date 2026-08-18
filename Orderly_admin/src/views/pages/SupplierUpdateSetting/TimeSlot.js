import React, { Fragment, useEffect, useState } from "react";
import { Button, Card, CardBody, Col, Input, Label, Row } from "reactstrap";
import Flatpickr from "react-flatpickr";
import TextField from "@mui/material/TextField";
import { TimePicker } from "@mui/x-date-pickers/TimePicker";
import { MobileTimePicker } from "@mui/x-date-pickers/MobileTimePicker";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import TimeSlotMain from "./TimeSlotMain";
import axios from "axios";
import { useSelector } from "react-redux";
import { json, useLocation } from "react-router-dom";
import toast from "react-hot-toast";

const TimeSlot = (props) => {
  const token = localStorage.getItem("token");
  const [data, setData] = useState([]);
  // const [allData, setAllData] = useState([])

  //   const dataPush = data.map((item) => {
  //     return item.time_details;
  //   });

  //   console.log("datapush", dataPush);

  const supplier = props.supplierData;

  useEffect(() => {
    if (supplier) {
      setData(supplier.time_slot);
    }
  }, [props, supplier]);

  const addTimeSlot = () => {
    axios
      .post(
        "/suppliertiming/update",
        {
          supplier_id: supplier.id,
          supplier_timing: data,
        },
        { headers: { Authorization: `Bearer ${token}` } }
      )
      .then((response) => {
        console.log("TimeSlot", response.data.data);
        toast.success(response.data.message);

        if (props && props.updateDone) {
          props.updateDone();
        }
      })
      .catch((err) => {
        console.log(err);
        toast.error(err.response.data.message);
      });
  };

  const statusChange = (day) => {
    let editData = data.map((i, index) => {
      if (i.day === day) {
        return {
          ...i,
          time_details: i.time_details.map((a) => {
            return { ...a, status: !a.status };
          }),
        };
      } else {
        return i;
      }
    });
    setData(editData);
  };

  const addTime = (index1) => {
    let editData = data.map((i, index) => {
      if (index === index1) {
        let timing = i.time_details;
        console.log("timing", timing);
        timing.push({
          id: 0,
          day: i.day,
          time_from: "10:00:00",
          time_to: "15:00:00",
          status: i.time_details[0].status,
        });
        return {
          ...i,
          time_details: timing,
        };
      } else {
        return i;
      }
    });
    setData(editData);
  };

  const removeTime = (id, day) => {
    let editData = data.map((i, index) => {
      if (i.day === day) {
        return {
          ...i,
          time_details: i.time_details.filter((time) => {
            if (time.id !== id) return time;
          }),
        };
      } else {
        return i;
      }
    });
    console.log("editData", editData);
    setData(editData);
  };

  const changeStartTime = (day, value, id) => {
    let editData = data.map((i) => {
      if (i.day === day) {
        return {
          ...i,
          time_details: i.time_details.map((a) => {
            if (a.id === id) {
              return { ...a, time_from: value };
            } else {
              return a;
            }
          }),
        };
      } else {
        return i;
      }
    });
    setData(editData);
  };

  const changeEndTime = (day, value, id) => {
    let editData = data.map((i) => {
      if (i.day === day) {
        return {
          ...i,
          time_details: i.time_details.map((a) => {
            if (a.id === id) {
              return { ...a, time_to: value };
            } else {
              return a;
            }
          }),
        };
      } else {
        return i;
      }
    });

    setData(editData);
  };

  return (
    <Fragment>
      <Card>
        <CardBody className="py-2 my-25">
          <Row className="mb-1">
            {data.map((i, index1) => {
              return (
                <Row key={index1}>
                  {i.day && (
                    <Col
                      sm="2"
                      className="mb-2"
                      style={{ marginTop: "0.6rem" }}
                    >
                      <div style={{ padding: "7px" }}>{i.day}</div>
                    </Col>
                  )}
                  <Col sm="2" style={{ marginTop: "0.6rem" }}>
                    <div style={{ display: "flex", padding: "5px" }}>
                      <div className="form-switch form-check-success">
                        <Input
                          type="switch"
                          id="switch-success"
                          name="success"
                          checked={
                            i.time_details && i.time_details.length
                              ? i.time_details[0].status
                              : false
                          }
                          onChange={(e) => {
                            statusChange(i.day);
                          }}
                        />
                      </div>
                      <div style={{ marginTop: "3px" }}>
                        {i.time_details && i.time_details[0].status === true
                          ? "Open"
                          : "Close"}
                      </div>
                    </div>
                  </Col>
                  {i.time_details[0].status && (
                    <Col>
                      {i.time_details &&
                        i.time_details.map((item, index) => {
                          return (
                            <>
                              <Row>
                                {/* {JSON.stringify(item)} */}
                                <Col sm="3" className="mb-1">
                                  {/* <TimePicker onChange={setFirstStartTime} value={firstStartTime} /> */}
                                  <TextField
                                    style={{ width: "100%" }}
                                    type="time"
                                    InputLabelProps={{
                                      shrink: true,
                                    }}
                                    onChange={(e) =>
                                      changeStartTime(
                                        i.day,
                                        e.target.value,
                                        item.id
                                      )
                                    }
                                    defaultValue={item.time_from}
                                  />
                                </Col>
                                <Col sm="3">
                                  <TextField
                                    style={{ width: "100%", border: "none" }}
                                    defaultValue={item.time_to}
                                    type="time"
                                    InputLabelProps={{
                                      shrink: true,
                                    }}
                                    onChange={(e) => {
                                      changeEndTime(
                                        i.day,
                                        e.target.value,
                                        item.id
                                      );
                                    }}
                                  />
                                </Col>

                                {i.time_details.length < 2 && (
                                  <Col
                                    sm="2"
                                    className="mb-1"
                                    style={{ marginTop: "0.6rem" }}
                                  >
                                    <>
                                      <Button
                                        className="me-1"
                                        color="success"
                                        onClick={() => {
                                          addTime(index1);
                                        }}
                                      >
                                        Add
                                      </Button>
                                    </>
                                  </Col>
                                )}

                                {index === 1 && (
                                  <Col sm="2" style={{ marginTop: "0.6rem" }}>
                                    <>
                                      <Button
                                        className="me-1"
                                        color="danger"
                                        onClick={() =>
                                          removeTime(item.id, i.day)
                                        }
                                      >
                                        -
                                      </Button>
                                    </>
                                  </Col>
                                )}
                              </Row>
                            </>
                          );
                        })}
                    </Col>
                  )}
                </Row>
              );
            })}
          </Row>

          <Row className="mb-1">
            <Col sm="2" className="mb-1">
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
