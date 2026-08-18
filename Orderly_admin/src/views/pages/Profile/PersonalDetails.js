// ** React Imports
import { Fragment, useState } from 'react'

// ** Third Party Components
import Select from 'react-select'
import Cleave from 'cleave.js/react'
import { useForm, Controller } from 'react-hook-form'
import 'cleave.js/dist/addons/cleave-phone.us'
import makeAnimated from 'react-select/animated'
// ** Reactstrap Imports
import { Row, Col, Form, Card, Input, Label, Button, CardBody, CardTitle, CardHeader, FormFeedback } from 'reactstrap'
import { useNavigate } from "react-router-dom"

// eslint-disable-line


// ** Utils
import { selectThemeColors } from '@utils'

// ** Demo Components
import DeleteAccount from './DeleteAccount'
import axios from 'axios'
import { useSelector } from 'react-redux'



const PersonalDetails = (props) => {
    const navigate = useNavigate()
    const vendors = props.vendors
    const token = localStorage.getItem('token')
    const data = useSelector((state) => state.user.userData);


    const [firstName, setFirstName] = useState(data.name)
    // const [lastName, setLastName] = useState(vendors.last_name)
    const [email, setEmail] = useState(data.email)
    const [phone, setPhone] = useState(data.phone)

    const updateData = () => {
        axios
            .post("/vendors/updatepersonaldetails", {
                vendor_id: vendors.id,
                first_name: firstName,
                // last_name: lastName,
                email: email,
                phone: phone

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
                    <CardTitle tag='h4'>Personal Details</CardTitle>
                </CardHeader>
                <CardBody className='py-2 my-25'>
                    <div>

                        <Row>
                            <Col sm='12' className='mb-1'>
                                <Label className='form-label' for='firstName'>
                                    First Name
                                </Label>

                                <Input id='firstName' placeholder='First Name' value={firstName} onChange={(e) => setFirstName(e.target.value)} />

                            </Col>

                            <Col sm='6' className='mb-1'>
                                <Label className='form-label' for='emailInput'>
                                    E-mail
                                </Label>
                                <Input id='emailInput' type='email' name='email' placeholder='Email' value={email}
                                    onChange={(e) => setEmail(e.target.value)}
                                />
                            </Col>
                            <Col sm='6' className='mb-1'>
                                <Label className='form-label' for='company'>
                                    Phone
                                </Label>
                                <Input id='company' name='company' placeholder='Phone' value={phone} onChange={(e) => setPhone(e.target.value)} maxLength='10' />
                            </Col>
                            <Col className='mt-2' sm='12'>
                                <Button type='submit' className='me-1' color='primary' onClick={updateData}>
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

export default PersonalDetails
