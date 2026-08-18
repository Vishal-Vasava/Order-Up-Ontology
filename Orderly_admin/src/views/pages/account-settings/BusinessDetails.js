// ** React Imports
import { Fragment, useEffect, useState } from 'react'

// ** Third Party Components
import Select from 'react-select'
import Cleave from 'cleave.js/react'
import { useForm, Controller } from 'react-hook-form'
import 'cleave.js/dist/addons/cleave-phone.us'
import makeAnimated from 'react-select/animated'
// ** Reactstrap Imports
import { Row, Col, Form, Card, Input, Label, Button, CardBody, CardTitle, CardHeader, FormFeedback } from 'reactstrap'
import { useNavigate } from "react-router-dom"
import BackImage from "@src/assets/images/profile/user-uploads/timeline.jpg"
import "./BusinessDetails.css"
import IconButton from '@mui/material/IconButton';





// eslint-disable-line


// ** Utils
import { selectThemeColors } from '@utils'

// ** Demo Components
import DeleteAccount from './DeleteAccount'
import axios from 'axios'
import { border } from '@mui/system'
import { Icon } from '@mui/material'
import EditSharpIcon from '@mui/icons-material/EditSharp';
import { useRef } from 'react';


const options = [
    { label: "Pending", value: 0 },
    { label: "Approve", value: 1 },
    { label: "Reject", value: 2 },
    { label: "Inactive", value: 3 }

];


const BusinessDetails = (props) => {

    const animatedComponents = makeAnimated()
    const token = localStorage.getItem('token')
    const navigate = useNavigate()
    const inputRef = useRef(null);
    const inputRef1 = useRef(null);
    const vendors = props.vendors

    // ** States

    const [email, setEmail] = useState(vendors.email)
    const [phone, setPhone] = useState(vendors.phone)
    const [storeName, setStoreName] = useState(vendors.name)
    const [address1, setAddress1] = useState(vendors.address_line_1)
    const [address2, setAddress2] = useState(vendors.address_line_2)
    const [city, setCity] = useState(vendors.city)
    const [state, setState] = useState(vendors.state)
    const [country, setCountry] = useState(vendors.country)
    const [zipcode, setZipcode] = useState(vendors.zipcode)
    const [changeStatus, setChangeStatus] = useState(options[vendors.status])
    const [selectedLogo, setSelectedLogo] = useState()
    const [logo, setLogo] = useState(vendors.logo)
    const [selectedBanner, setSelectedBanner] = useState()
    const [banner, setBanner] = useState(vendors.banner)
    const [datas, setDatas] = useState("")

    const formData = new FormData();



    console.log("datas", datas[1]);
    console.log("selectedBanner", selectedBanner);




    useEffect(() => {
        if (!selectedLogo) {
            setLogo(logo)
            return
        }
        const objectUrl = URL.createObjectURL(selectedLogo)
        setLogo(objectUrl)
        return () => URL.revokeObjectURL(objectUrl)
    }, [selectedLogo])

    useEffect(() => {
        if (!selectedBanner) {
            setBanner(banner)
            return
        }
        console.log("cdsfvds");
        const objectUrl = URL.createObjectURL(selectedBanner)
        setBanner(objectUrl)
        return () => URL.revokeObjectURL(objectUrl)
    }, [selectedBanner])

    const UpdateMenuCatagory = (e) => {
        e.preventDefault()


        let form = new FormData();

        form.append('vendor_id', vendors.id)
        form.append('status', changeStatus.value)
        form.append('store_id', vendors.store_id)
        form.append('name', storeName)
        form.append('phone', phone)
        form.append('email', email)
        form.append('address_line_1', address1)
        form.append('address_line_2', address2)
        form.append('city', city)
        form.append('state', state)
        form.append('zipcode', zipcode)
        form.append('country', country);
        form.append("logo", selectedLogo);
        form.append("banner", selectedBanner);

        axios({
            method: "post",
            url: "/vendors/updatebusinessdetails",

            headers: {
                "content-type": "application/json",
                Authorization: `Bearer ${token}`,
            },
            data: form,
        })


            .then((response) => {
                console.log("response Vendors", response);
                navigate(`${process.env.REACT_APP_FOLDER}/vendors`)
                setImage("");


            })
            .catch((err) => {
                console.log(err)
            })
    }

    const discardClick = () => {
        navigate(`${process.env.REACT_APP_FOLDER}/vendors`)
    }

    const handleOnchange = (val) => {
        console.log("val", val);
        setChangeStatus(val)
    }


    const handleLogoClick = () => {
        inputRef.current.click();
    };

    const handleBannerClick = () => {
        inputRef1.current.click();
    };
    const handleLogo = e => {
        if (!e.target.files || e.target.files.length === 0) {
            setSelectedLogo(undefined)
            return
        }
        setSelectedLogo(e.target.files[0])
    };

    const handleBanner = e => {
        if (!e.target.files || e.target.files.length === 0) {
            setSelectedBanner(undefined)
            return
        }
        setSelectedBanner(e.target.files[0])
    };



    return (
        <Fragment>
            <form onSubmit={UpdateMenuCatagory}>
                <Card>
                    <CardHeader className='border-bottom'>
                        <CardTitle tag='h4'>Business Details</CardTitle>
                    </CardHeader>
                    <CardBody className='py-2 mb-10'>

                        <div className='d-flex'>


                            <img className='rounded' style={{ objectFit: "cover" }} src={banner} alt='Generic placeholder image' height='200' width='100%' />
                            <div className='mt-4' style={{ position: "absolute", justifyItems: "end", right: "40px" }}>
                                <input
                                    style={{ display: 'none' }}
                                    ref={inputRef1}
                                    type="file"
                                    onChange={handleBanner}
                                />
                                <IconButton tag={Label} size='sm' className='editbtn' onClick={handleBannerClick}>
                                    <EditSharpIcon style={{ color: "white" }} />

                                    <Input type='file' hidden accept='image/*' />
                                </IconButton>
                            </div>

                            <div style={{ position: "absolute" }}>

                                <img className='me-50 logoimg' src={logo} alt='Generic placeholder image' height='100' width='100' />
                                <div>

                                    <input
                                        style={{ display: 'none' }}
                                        ref={inputRef}
                                        type="file"
                                        onChange={handleLogo}
                                    />
                                    <IconButton tag={Label} size='sm' className='editbtn' onClick={handleLogoClick}>
                                        <EditSharpIcon style={{ color: "white" }} />

                                        <Input type='file' hidden accept='image/*' />
                                    </IconButton>
                                </div>
                            </div>
                        </div>

                        <Row>

                            <Col sm='12' className='mb-1 mt-5'>
                                <Label className='form-label' for='storeName'>
                                    Store Name
                                </Label>
                                <Input id='store' name='storename' placeholder='Store Name' value={storeName} onChange={(e) => setStoreName(e.target.value)} />
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

                            <Col sm='6' className='mb-1'>
                                <Label className='form-label' for='address'>
                                    Address Line 1
                                </Label>
                                <Input id='address' name='address' placeholder='12, Business Park' value={address1} onChange={(e) => setAddress1(e.target.value)} />
                            </Col>
                            <Col sm='6' className='mb-1'>
                                <Label className='form-label' for='address'>
                                    Address Line 2
                                </Label>
                                <Input id='address' name='address' placeholder='12, Business Park' value={address2} onChange={(e) => setAddress2(e.target.value)} />
                            </Col>
                            <Col sm='6' className='mb-1'>
                                <Label className='form-label' for='accountState'>
                                    City
                                </Label>
                                <Input id='City' name='City' placeholder='California' value={city}
                                    onChange={(e) => setCity(e.target.value)} />
                            </Col>
                            <Col sm='6' className='mb-1'>
                                <Label className='form-label' for='accountState'>
                                    State
                                </Label>
                                <Input id='accountState' name='state' placeholder='California' value={state}
                                    onChange={(e) => setState(e.target.value)} />
                            </Col>
                            <Col sm='6' className='mb-1'>
                                <Label className='form-label' for='zipCode'>
                                    Zip Code
                                </Label>
                                <Input id='zipCode' name='zipCode' placeholder='123456' maxLength='6' value={zipcode}
                                    onChange={(e) => setZipcode(e.target.value)} />
                            </Col>
                            <Col sm='6' className='mb-1'>
                                <Label className='form-label' for='country'>
                                    Country
                                </Label>
                                <Input id='Country' name='Country' placeholder='Country' value={country}
                                    onChange={(e) => setCountry(e.target.value)} />
                            </Col>
                            <Col sm='12' className='mb-1'>
                                <Label className='form-label' for='Status'>
                                    Status
                                </Label>

                                <Select
                                    isClearable={false}
                                    theme={selectThemeColors}
                                    closeMenuOnSelect={true}
                                    components={animatedComponents}
                                    value={changeStatus}
                                    onChange={handleOnchange}
                                    options={options}
                                    className='react-select'
                                    classNamePrefix='select'
                                />

                            </Col>
                            <Col className='mt-2' sm='12'>
                                <Button type='submit' className='me-1' color='primary' >
                                    Save changes
                                </Button>
                                <Button color='secondary' outline onClick={discardClick}>
                                    Discard
                                </Button>
                            </Col>
                        </Row>

                    </CardBody>
                </Card>
            </form>
        </Fragment>
    )
}

export default BusinessDetails
