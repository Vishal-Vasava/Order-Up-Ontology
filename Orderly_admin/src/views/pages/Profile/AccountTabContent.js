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

const options = [
  { label: "Pending", value: 0 },
  { label: "Approve", value: 1 },
  { label: "Reject", value: 2 },
  { label: "Inactive", value: 3 }

];


const AccountTabs = (props) => {
  // ** Hooks



  // ** States
  const [avatar, setAvatar] = useState("")
  const animatedComponents = makeAnimated()
  const token = localStorage.getItem('token')
  const navigate = useNavigate()



  const vendors = props.vendors


  // const [firstName, setFirstName] = useState(vendors.first_name)
  // const [lastName, setLastName] = useState(vendors.last_name)
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

  console.log("vendore.id", vendors.id);
  // console.log("vendore.status", changeStatus.value);






  const UpdateMenuCatagory = () => {
    axios
      .post("/vendors/changeStatus", {
        vendor_id: vendors.id,
        status: changeStatus.value,

      }, { headers: { Authorization: `Bearer ${token}` } })
      .then((response) => {
        console.log("response Vendors", response);
        navigate(`${process.env.REACT_APP_FOLDER}/vendors`)

      })
      .catch((err) => {
        console.log(err)
      })
    navigate(`${process.env.REACT_APP_FOLDER}/vendors`)

  }

  const discardClick = () => {
    navigate(`${process.env.REACT_APP_FOLDER}/vendors`)
  }




  const handleOnchange = (val) => {
    console.log("val", val);
    setChangeStatus(val)
  }


  return (
    <Fragment>
      <Card>
        <CardHeader className='border-bottom'>
          <CardTitle tag='h4'>Profile Details</CardTitle>
        </CardHeader>
        <CardBody className='py-2 my-25'>
          <div className='d-flex'>
            <div className='me-25'>
              <img className='rounded me-50' style={{ objectFit: "contain" }} src={vendors.logo} alt='Generic placeholder image' height='100' width='100' />
            </div>
            <div className='d-flex align-items-end mt-75 ms-1'>
              <div>
                <Button tag={Label} className='mb-75 me-75' size='sm' color='primary'>
                  Upload
                  <Input type='file' hidden accept='image/*' />
                </Button>
                <Button className='mb-75' color='secondary' size='sm' outline>
                  Reset
                </Button>
                <p className='mb-0'>Allowed JPG, GIF or PNG. Max size of 800kB</p>
              </div>
            </div>
          </div>
          <Form className='mt-2 pt-50'
          // onSubmit={handleSubmit(onSubmit)}
          >
            <Row>
              {/* <Col sm='6' className='mb-1'>
                <Label className='form-label' for='firstName'>
                  First Name
                </Label>

                <Input id='firstName' placeholder='First Name' value={firstName} onChange={(e) => setFirstName(e.target.value)} />



              </Col> */}
              {/* <Col sm='6' className='mb-1'>
                <Label className='form-label' for='lastName'>
                  Last Name
                </Label>


                <Input id='lastName' placeholder='LastName' value={lastName} onChange={(e) => setLastName(e.target.value)} />



              </Col> */}
              <Col sm='12' className='mb-1'>
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

              {/* <Col sm='6' className='mb-1'>
                <Label className='form-label' for='language'>
                  Language
                </Label>
                <Select
                  id='language'
                  isClearable={false}
                  className='react-select'
                  classNamePrefix='select'
                  options={languageOptions}
                  theme={selectThemeColors}
                  defaultValue={languageOptions[0]}
                />
              </Col>
              <Col sm='6' className='mb-1'>
                <Label className='form-label' for='timeZone'>
                  Timezone
                </Label>
                <Select
                  id='timeZone'
                  isClearable={false}
                  className='react-select'
                  classNamePrefix='select'
                  options={timeZoneOptions}
                  theme={selectThemeColors}
                  defaultValue={timeZoneOptions[0]}
                />
              </Col>
              <Col sm='6' className='mb-1'>
                <Label className='form-label' for='currency'>
                  Currency
                </Label>
                <Select
                  id='currency'
                  isClearable={false}
                  className='react-select'
                  classNamePrefix='select'
                  options={currencyOptions}
                  theme={selectThemeColors}
                  defaultValue={currencyOptions[0]}
                />
              </Col> */}
              <Col className='mt-2' sm='12'>
                <Button type='submit' className='me-1' color='primary' onClick={UpdateMenuCatagory}>
                  Save changes
                </Button>
                <Button color='secondary' outline onClick={discardClick}>
                  Discard
                </Button>
              </Col>
            </Row>
          </Form>
        </CardBody>
      </Card>
      <DeleteAccount />
    </Fragment>
  )
}

export default AccountTabs
