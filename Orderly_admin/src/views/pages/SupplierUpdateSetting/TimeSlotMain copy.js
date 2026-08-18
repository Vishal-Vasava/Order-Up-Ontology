import React, { useEffect, useState } from 'react'
import { Button, Col, Input, Row } from 'reactstrap'
import Flatpickr from 'react-flatpickr'
// import TextField from '@mui/material/TextField';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
// import { TimePicker } from '@mui/x-date-pickers/TimePicker';
import TextField from "@material-ui/core/TextField";

import axios from 'axios';
import { useSelector } from 'react-redux';


const TimeSlotMain = (props) => {

    console.log("props.data", props.data);
    const getData = props.data

    const [array, setArray] = useState([])

    const [status, setStatus] = useState(getData.status)
    const [firstStartTime, setFirstStartTime] = useState(getData.time_from)
    const [firstEndTime, setFirstEndTime] = useState(getData.time_to)
    const [secondStartTime, setSecondStartTime] = useState(getData.time_from)
    const [secondEndTime, setSecondEndTime] = useState(getData.time_to)

    // console.log("status", status);

    // props.allData.({ day: props.day, time_from: firstStartTime, time_to: firstEndTime, status: status })

    // console.log("day", props.day);


    console.log("getData", getData);
    // console.log("firstEndTime", firstEndTime);
    // console.log("secondStartTime", secondStartTime);
    // console.log("secondEndTime", secondEndTime);



    const [list, setList] = useState([]);
    const handleDelete = (ids) => {
        const id = ids.id
        console.log("id delete", id);
        const copy = list.slice();
        const index = copy.findIndex(({ id: ID }) => id === ID);
        console.log(index);
        copy.splice(index, 1);
        console.log("copy copt", index);
        setList(copy);
        setArray([])

        props.setAllData(props.allData.filter((i) => i.id !== id))

    };
    const handleAdd = (e) => {
        console.log("esadsadasadadadadsa", e);
        setList([...list, { id: props.allData.length + 1 }]);

        setArray([{ id: props.allData.length + 1, day: props.day, time_from: secondStartTime, time_to: secondEndTime, status: true }])
        props.setAllData([...props.allData, { id: props.allData.length + 1, day: props.day, time_from: secondStartTime, time_to: secondEndTime, status: true }])

    };

    return (
        <>
            <Row className='mb-0' >
                {props.day ?
                    <Col sm='2' className='mb-1'>
                        <div style={{ padding: "7px" }}>{props.day}</div>
                    </Col> : null}
                <Col sm='2' >

                    <div style={{ display: "flex", padding: "5px" }}>

                        <div className='form-switch form-check-success'>

                            <Input type='switch' id='switch-success' name='success'
                                checked={status}
                                onChange={(e) => {

                                    console.log("props.inddex + 1", props.index);
                                    // const edit = props.allData.map((i) => { if (i.id === (props.index)) { return { id: i.id, day: i.day, time_from: i.time_from, time_to: i.time_to, status: !status } } else { return { id: i.id, day: i.day, time_from: i.time_from, time_to: i.time_to, status: i.status } } })
                                    // props.setAllData(edit)
                                    setStatus(e.target.checked);
                                }}

                            />
                        </div>
                        <div style={{ marginTop: "3px" }}>{status === true ? "Open" : "Close"}</div>
                    </div>
                </Col>
                {status === true ?
                    <>
                        <Col sm="2">
                            {/* <TimePicker onChange={setFirstStartTime} value={firstStartTime} /> */}
                            <TextField
                                style={{ width: "100%" }}
                                type="time"
                                InputLabelProps={{
                                    shrink: true
                                }}
                                onChange={(e) => {
                                    setFirstStartTime(e.target.value)
                                    const edit = props.allData.map((i) => { if (i.id === (props.index)) { return { id: i.id, day: i.day, time_from: e.target.value, time_to: i.time_to, status: i.status } } else { return { id: i.id, day: i.day, time_from: i.time_from, time_to: i.time_to, status: i.status } } })

                                    props.setAllData(edit)

                                }
                                }
                                defaultValue={firstStartTime}
                            />
                        </Col>
                        <Col sm="2" >

                            <TextField
                                style={{ width: "100%" }}
                                defaultValue={firstEndTime}
                                type="time"
                                InputLabelProps={{
                                    shrink: true
                                }}
                                onChange={(e) => {

                                    setFirstEndTime(e.target.value)
                                    const edit = props.allData.map((i) => { if (i.id === (props.index)) { return { id: i.id, day: i.day, time_from: i.time_from, time_to: e.target.value, status: i.status } } else { return { id: i.id, day: i.day, time_from: i.time_from, time_to: i.time_to, status: i.status } } })

                                    props.setAllData(edit)
                                }

                                }




                            />
                        </Col>
                        {list.length === 0 ?
                            <Col sm="2">
                                <>
                                    <Button className='me-1' color='success' onClick={handleAdd}>
                                        Add
                                    </Button>
                                </>
                            </Col> : null}
                    </> : null}
            </Row>


            {status === true ?

                array.map((item, index) => (


                    <>
                        {console.log("item", item)}
                        <Row className='mb-1'>
                            <Col sm='2' className='mb-1'></Col>
                            <Col sm='2' className='mb-1'></Col>
                            <Col sm="2">

                                <TextField
                                    style={{ width: "100%" }}
                                    defaultValue={secondStartTime}
                                    type="time"
                                    InputLabelProps={{
                                        shrink: true
                                    }}
                                    onChange={(e) => {
                                        setSecondStartTime(e.target.value,)
                                        const edit = props.allData.map((i) => { if (i.id === (item.id)) { return { id: i.id, day: i.day, time_from: e.target.value, time_to: i.time_to, status: i.status } } else { return { id: i.id, day: i.day, time_from: i.time_from, time_to: i.time_to, status: i.status } } })

                                        props.setAllData(edit)

                                    }}
                                />

                            </Col>
                            <Col sm="2" >

                                <TextField
                                    style={{ width: "100%" }}
                                    defaultValue={secondEndTime}
                                    type="time"
                                    InputLabelProps={{
                                        shrink: true
                                    }}
                                    onChange={(e) => {
                                        setSecondEndTime(e.target.value)
                                        const edit = props.allData.map((i) => { if (i.id === (item.id)) { return { id: i.id, day: i.day, time_from: i.time_from, time_to: e.target.value, status: i.status } } else { return { id: i.id, day: i.day, time_from: i.time_from, time_to: i.time_to, status: i.status } } })

                                        props.setAllData(edit)
                                    }}

                                />
                            </Col>
                            <Col sm="2">
                                <>
                                    <Button className='me-1' color='danger' onClick={() => handleDelete(item, index)}>
                                        -
                                    </Button>
                                </>
                            </Col>
                        </Row>
                    </>

                )
                )

                : null}



        </>
    )
}

export default TimeSlotMain