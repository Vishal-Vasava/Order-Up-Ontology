// ** React Imports
import React, { Fragment, useEffect, useRef, useState } from "react";

// ** Third Party Components
import Select from "react-select";
import Cleave from "cleave.js/react";
import { useForm, Controller } from "react-hook-form";
import "cleave.js/dist/addons/cleave-phone.us";
import makeAnimated from "react-select/animated";
// ** Reactstrap Imports
import { Row, Col, Form, Card, Input, Label, Button, CardBody, CardTitle, CardHeader, FormFeedback, CardText } from 'reactstrap'
import { useNavigate } from "react-router-dom"
import EditSharpIcon from '@mui/icons-material/EditSharp';
import "./BusinessDetail.css"

import CarouselKeyboard from './../../components/carousel/CarouselKeyboard'
import {

  carouselKeyboard,
} from './../../components/carousel/CarouselSourceCode'



// eslint-disable-line

// ** Utils
import { selectThemeColors } from "@utils";

// ** Demo Components
import DeleteAccount from "./DeleteAccount";
import axios from "axios";
import { useSelector } from "react-redux";
import { IconButton } from "@mui/material";

const options = [
  { label: "Pending", value: 0 },
  { label: "Approve", value: 1 },
  { label: "Reject", value: 2 },
  { label: "Inactive", value: 3 },
];

const colorOptions = [{ value: 3, label: "Punjabi" }];

const BusinessDetails = (props) => {
  // ** Hooks
  const data = useSelector((state) => state.user.userData);



  // ** States
  const [avatar, setAvatar] = useState("")
  const animatedComponents = makeAnimated()
  const token = localStorage.getItem('token')
  const navigate = useNavigate()
  const inputRef = useRef(null);
  const inputRef1 = useRef(null);

  // const cuisinesByobj = JSON.parse(data.cuisines);

  const [email, setEmail] = useState(data.email)
  const [phone, setPhone] = useState(data.phone)
  const [storeName, setStoreName] = useState(data.business_name)
  const [address1, setAddress1] = useState(data.address_line_1)
  const [address2, setAddress2] = useState(data.address_line_2)
  const [city, setCity] = useState(data.city)
  const [state, setState] = useState(data.state)
  const [country, setCountry] = useState(data.country)
  const [zipcode, setZipcode] = useState(data.zipcode)
  const [masterCusions, setMasterCusions] = useState([]);
  const [cuisines, setCuisines] = useState([])
  const [cuisinesOptions, setCuisinesOptions] = useState([])
  const [defaultCuisne, setDefaultCuisine] = useState([])
  const [selectedLogo, setSelectedLogo] = useState()
  const [logo, setLogo] = useState(data.logo)
  const [selectedBanner, setSelectedBanner] = useState()
  const [banner, setBanner] = useState(data.banner)


  const [images, setImages] = useState([
    { id: "1", src: "https://www.placecage.com/200/300" },
    { id: "2", src: "https://www.placecage.com/g/200/300" },
    { id: "3", src: "https://www.placecage.com/c/200/300" },
    { id: "4", src: "https://www.placecage.com/gif/200/300" },
    { id: "5", src: "https://www.placecage.com/300/300" },
    { id: "6", src: "https://www.placecage.com/g/300/300" },
    { id: "7", src: "https://www.placecage.com/gif/300/300" },
    { id: "8", src: "https://www.placecage.com/c/300/300" },
    { id: "9", src: "https://www.placecage.com/400/400" }
  ]);



  console.log("setCuisnes",);

  useEffect(() => {
    console.log(images);
  }, []);

  const handleCick = (evt, id) => {
    setImages(images.filter((image) => image.id !== id));
  };


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


  // useEffect(() => {
  //     if (cuisinesByobj) {

  //         const cusionsArray = cuisinesByobj.map((item) => {

  //             return { value: item.id, label: item.title }

  //         }
  //         )
  //         setDefaultCuisine(cusionsArray)
  //     }


  // }, [])




  useEffect(() => {
    if (!selectedBanner) {
      setBanner(banner);
      return;
    }
    console.log("cdsfvds");
    const objectUrl = URL.createObjectURL(selectedBanner);
    setBanner(objectUrl);
    return () => URL.revokeObjectURL(objectUrl);
  }, [selectedBanner]);




  return (
    <Fragment>

      <Card>
        <CardHeader className='border-bottom'>
          <CardTitle tag='h4'>Business Details</CardTitle>
        </CardHeader>
        <CardBody>


          <Row>
            <Row>
              <Col sm='6'>
                <Card title='Keyboard Example' code={carouselKeyboard}>
                  <CarouselKeyboard />
                </Card>
              </Col>


              <Col sm="6" className='mb-1'>
                <div style={{ display: "flex", flexWrap: "wrap", gap: "8px" }}>
                  {images.map(({ src, id }) => (
                    <div>
                      <div ng-repeat="file in imagefinaldata" class="img_wrp" style={{ marginRight: "15px" }}>
                        <img style={{ height: "100px", width: "100px" }} src={src} class="imgResponsiveMax" alt="" />
                        <button class="close" onClick={(evt) => handleCick(evt, id)}>X</button>
                      </div>

                    </div>
                  ))}
                </div>
              </Col>
            </Row>




            <Col sm='12' className='mb-1'>
              <Label className='form-label' for='Tourname'>
                Tour Name
              </Label>
              <Input id='store' name='Tourname' placeholder='Tour Name' value={storeName} onChange={(e) => setStoreName(e.target.value)} />
            </Col>
            <Col sm='12' className='mb-1'>
              <Label className='form-label' for='shortdescription'>
                Tour Short Description
              </Label>
              <Input id='shortdescription' type='textarea' rows='3' name='shortdescription' placeholder='Tour Short Description' value={email}
                onChange={(e) => setEmail(e.target.value)}
              />
            </Col>
            <Col sm='12' className='mb-1'>
              <Label className='form-label' for='fulldescription'>
                Tour Full Description
              </Label>
              <Input type='textarea' id='fulldescription' rows="5" name='fulldescription' placeholder='Tour Full Description' value={phone} onChange={(e) => setPhone(e.target.value)} />
            </Col>

            <Col sm='6' className='mb-1'>
              <Label className='form-label' for='price'>
                Price
              </Label>
              <Input id='price' type='number' name='price' placeholder='Price' value={address1} onChange={(e) => setAddress1(e.target.value)} />
            </Col>

            {/* <Col sm='12' className='mb-1'>
                            <h6>Cuisions Select</h6>
                            <Select
                                isClearable={false}
                                theme={selectThemeColors}
                                value={defaultCuisne}
                                // defaultValue={defaultCuisne}
                                options={cuisinesOptions}
                                onChange={handleChange}
                                isMulti
                                className='react-select'
                                classNamePrefix='select'
                            />

                        </Col> */}
            <Col className='mt-2' sm='12'>
              <Button type='submit' className='me-1' color='primary' >
                Save changes
              </Button>
              {/* <Button color='secondary' outline onClick={discardClick}>
                Discard
              </Button> */}
            </Col>
          </Row>

        </CardBody>
      </Card>

    </Fragment>
  )
}

export default BusinessDetails
