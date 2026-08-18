// ** React Imports
import React, { Fragment, useEffect, useState } from "react";

// ** Third Party Components
import "cleave.js/dist/addons/cleave-phone.us";

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
} from "reactstrap";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import Select from "react-select";
import makeAnimated from "react-select/animated";
import { selectThemeColors } from "@utils";
import { useSelector } from "react-redux";

const groupedOptions = [
    { value: "vanilla", label: "Vanilla" },
    { value: "Dark Chocolate", label: "Dark Chocolate" },
    { value: "chocolate", label: "Chocolate" },
    { value: "strawberry", label: "Strawberry" },
    { value: "salted-caramel", label: "Salted Caramel" },
];

const Settings = (props) => {
    const navigate = useNavigate()
    const vendors = props.vendors
    const token = localStorage.getItem('token')
    const data = useSelector((state) => state.user.userData);


    const [tax, setTax] = useState(data.tax)
    const [deliveryFess, setDeliveryFess] = useState(data.delivery_fees)
    const [dining, setDining] = useState(data.table_booking)
    const [takeAway, setTakeAway] = useState(data.take_away)
    const [delivery, setDelivery] = useState(data.delivery)
    const animatedComponents = makeAnimated()

    const updateSetting = () => {
        axios
            .post("/vendors/updatestoresetting", {
                store_id: vendors.store_id,
                tax,
                delivery_fees: deliveryFess,
                table_booking: dining,
                take_away: takeAway,
                delivery: delivery

            }, { headers: { Authorization: `Bearer ${token}` } })
            .then((response) => {
                console.log("res", response);
            })
            .catch((err) => {
                console.log(err.response.data.message);
            })
    }

    const discardClick = () => {
        navigate(`${process.env.REACT_APP_FOLDER}/vendors`)
    }
    return (
        <Fragment>
            <Card>
                <CardHeader className='border-bottom'>
                    <CardTitle tag='h4'>Settings</CardTitle>
                </CardHeader>
                <CardBody className='py-2 my-25'>
                    <div>

                        <Row>
                            <Col sm='6' className='mb-1'>
                                <Label className='form-label' for='tax'>
                                    Tax
                                </Label>

                                <Input id='firstName' placeholder='Tax' value={tax} onChange={(e) => setTax(e.target.value)} />

                            </Col>
                            <Col sm='6' className='mb-1'>
                                <Label className='form-label' for='delivery'>
                                    Delivery Fees
                                </Label>
                                <Input id='lastName' placeholder='Delivery Fees' value={deliveryFess} onChange={(e) => setDeliveryFess(e.target.value)} />
                            </Col>
                            <Col sm='4' className='mb-1'>
                                <Label className='form-check-label mb-1' for='Services'>
                                    Services
                                </Label>
                                <div style={{ display: "flex", justifyContent: "space-between" }}>
                                    <div className='form-check form-check-primary'>
                                        <Input type='checkbox' id='Dining' defaultChecked={dining}
                                            onChange={(e) => setDining(e.target.checked ? 1 : 0)} />
                                        <Label className='form-check-label' for='Dining' >
                                            Dining
                                        </Label>
                                    </div>
                                    <div className='form-check form-check-primary'>
                                        <Input type='checkbox' id='takeaway' defaultChecked={takeAway}
                                            onChange={(e) => setTakeAway(e.target.checked ? 1 : 0)} />
                                        <Label className='form-check-label' for='takeaway' >
                                            Take-away
                                        </Label>
                                    </div>
                                    <div className='form-check form-check-primary'>
                                        <Input type='checkbox' id='Delivery' defaultChecked={delivery}
                                            onChange={(e) => setDelivery(e.target.checked ? 1 : 0)} />
                                        <Label className='form-check-label' for='Delivery'>
                                            Delivery
                                        </Label>
                                    </div>
                                </div>
                            </Col>
                            <Col sm='2' className='mb-1'></Col>

                            <Col className='mt-2' sm='12'>
                                <Button type='submit' className='me-1' color='primary' onClick={updateSetting}>
                                    Save changes
                                </Button>
                                <Button color='secondary' outline onClick={discardClick}>
                                    Discard
                                </Button>
                            </Col>
                        </Row>

                    </div>
                </CardBody>
            </Card>

        </Fragment>
    )
}

export default Settings
