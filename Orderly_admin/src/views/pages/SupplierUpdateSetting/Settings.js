// ** React Imports
import React, { Fragment, useEffect, useRef, useState } from "react";

// ** Third Party Components
import { useForm, Controller } from "react-hook-form";
import makeAnimated from "react-select/animated";

import Select from "react-select"; // eslint-disable-line
// ** Reactstrap Imports
import {
    Row,
    Col,
    Form,
    Card,
    Input,
    Label,
    Button,
    CardBody,
    CardTitle,
    CardHeader,
    FormFeedback,
    CardText,
} from "reactstrap";
import { useLocation, useNavigate } from "react-router-dom";
import EditSharpIcon from "@mui/icons-material/EditSharp";

import toast from "react-hot-toast";

import CarouselKeyboard from "./../../components/carousel/CarouselKeyboard";
import { carouselKeyboard } from "./../../components/carousel/CarouselSourceCode";
import userPlaceHolder from "../../../assets/images/avatars/avatar-blank.png";
import { PhotoCamera, PlayArrow } from "@mui/icons-material";

import AutoComplete from "@components/autocomplete";

// eslint-disable-line

// ** Utils
import { selectThemeColors } from "@utils";

// ** Demo Components
import axios from "axios";
import { useSelector } from "react-redux";
import { Autocomplete, Chip, IconButton, TextField } from "@mui/material";
import TimeSlot from "../../pages/account-settings/TimeSlot";


const options = [
    { label: "Pending", value: 0 },
    { label: "Approve", value: 1 },
    { label: "Reject", value: 2 },
    { label: "Inactive", value: 3 },
];

const Settings = (props) => {
    const data = useSelector((state) => state.user.userData);
    const location = useLocation();
    const tour = props.tourData
    const animatedComponents = makeAnimated();
    const token = localStorage.getItem("token");
    const navigate = useNavigate();

    const [price, setPrice] = useState(tour ? tour.price : "");
    const [time, setTime] = useState(tour ? tour.time : "");
    const [slot, setSlot] = useState(tour ? tour.no_of_slot : "");
    const [autoAccepted, setAutoAccepted] = useState({
        label: tour
            ? tour.auto_accepted
                ? "Auto Accepted"
                : "Confirmation Required"
            : "",
        value: tour ? tour.auto_accepted : "",
    });


    const updateTour = () => {
        axios
            .post(
                "/product/update",
                {
                    id: tour.id,
                    title: tour.title,
                    price: price,
                    time: time,
                    status: true,
                    short_description: tour.short_description,
                    full_description: tour.full_description,
                    activity_id: tour.activity_id,
                    highlights: JSON.stringify(tour.highlights),
                    exclusions: JSON.stringify(tour.exclusions),
                    inclusions: JSON.stringify(tour.inclusions),
                    auto_accepted: autoAccepted.value,
                    no_of_slot: slot,
                },
                { headers: { Authorization: `Bearer ${token}` } }
            )
            .then((response) => {
                navigate(`${process.env.REACT_APP_FOLDER}/product-listing`);
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
                {!tour ?
                    <CardHeader>
                        <CardTitle tag="h4">Create Tour</CardTitle>
                    </CardHeader> : ""}
                <CardBody>
                    <Row>

                        <Col sm="6" className="mb-1">
                            <Label className="form-label" for="price">
                                Time
                            </Label>
                            <Input
                                id="price"
                                // type="number"
                                name="price"
                                placeholder="2-3 hours"
                                value={time}
                                onChange={(e) => setTime(e.target.value)}
                            />
                        </Col>
                        <Col sm="6" className="mb-1">
                            <Label className="form-label" for="price">
                                Price (Per person)
                            </Label>
                            <Input
                                id="price"
                                type="number"
                                name="price"
                                placeholder="Enter price"
                                value={price}
                                onChange={(e) => setPrice(e.target.value)}
                            />
                        </Col>
                        <Col sm="6" className="mb-1">
                            <Label className="form-label" for="price">
                                Number of slot
                            </Label>
                            <Input
                                id="no_of_slot"
                                type="number"
                                name="no_of_slot"
                                placeholder="Number of slot"
                                value={slot}
                                onChange={(e) => setSlot(e.target.value)}
                            />
                        </Col>

                        <Col sm="6" className="mb-1">
                            <Label className="form-label" for="price">
                                Auto Accepted
                            </Label>
                            <Select
                                isClearable={false}
                                theme={selectThemeColors}
                                closeMenuOnSelect={true}
                                components={animatedComponents}
                                value={autoAccepted}
                                onChange={(e) => {
                                    // console.log("e", e);
                                    setAutoAccepted(e);
                                }}
                                // defaultValue={{
                                //   label: allData.order_status,
                                //   value: allData.order_status,
                                // }}
                                placeholder="Select"
                                options={[
                                    { label: "Auto Accepted", value: true },
                                    { label: "Confirmation Required", value: false },
                                ]}
                                className="react-select"
                                classNamePrefix="select"
                            />
                        </Col>



                        <Col className="mt-2" sm="12">
                            <Button
                                type="submit"
                                className="me-1"
                                color="primary"
                                onClick={updateTour}
                            >
                                Submit
                            </Button>



                        </Col>
                    </Row>
                </CardBody>
            </Card>
        </Fragment >
    );
};

export default Settings;  
