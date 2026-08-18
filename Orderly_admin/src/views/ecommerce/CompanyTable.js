// ** Custom Components
import Avatar from '@components/avatar'
import "./CompanyTable.css"

// ** Reactstrap Imports
import { Table, Card, CardTitle } from 'reactstrap'

// ** Icons Imports
import { Monitor, Coffee, Watch, TrendingUp, TrendingDown } from 'react-feather'
import React, { useEffect, useState } from 'react'
import axios from 'axios'
import { borderRadius } from '@mui/system'

const CompanyTable = () => {
  // ** vars
  const token = localStorage.getItem('token')
  const [data,setData]=useState([]);


  useEffect(() => {
    //we will change it to getVendors to getTopVendors
    if(token){
      axios
      .get("/vendors/getvendors",
          { headers: { Authorization: `Bearer ${token}` } })
      .then((response) => {
          // console.log("res", response);
          // console.log(response.data.token); 
          console.log("Vendors Listing", response.data.data)
          // response.data.data
          response.data.data.forEach(element => {
           
            element["orders"]='23.4k';
          
            element["time"]='last 7 days';
            element["revenue"]='891.2';
            element["sales"]='68'; 
            element["salesUp"]= Math.random() < 0.5;

          
             
          });
          setData(response.data.data)

      })
      .catch((err) => {
          // console.log(err.response.data.message);
          console.log(err)
          // alert(err.response.data.message);
      })
    }
  
}, [token])


  const data1 = [
    {
      img: require('@src/assets/images/icons/toolbox.svg').default,
      name: 'Dixons',
      email: 'meguc@ruj.io',
      icon: <Monitor size={18} />,
      category: 'Technology',
      orders: '23.4k',
      time: '24 hours',
      revenue: '891.2',
      sales: '68'
    },
    {
      img: require('@src/assets/images/icons/parachute.svg').default,
      name: 'Motels',
      email: 'vecav@hodzi.co.uk',
      icon: <Coffee size={18} />,
      category: 'Grocery',
      views: '78k',
      time: '2 days',
      revenue: '668.51',
      sales: '97',
      salesUp: true
    },
    {
      img: require('@src/assets/images/icons/brush.svg').default,
      name: 'Zipcar',
      email: 'davcilse@is.gov',
      icon: <Watch size={18} />,
      category: 'Fashion',
      views: '162',
      time: '5 days',
      revenue: '522.29',
      sales: '62',
      salesUp: true
    },
    {
      img: require('@src/assets/images/icons/star.svg').default,
      name: 'Owning',
      email: 'us@cuhil.gov',
      icon: <Monitor size={18} />,
      category: 'Technology',
      views: '214',
      time: '24 hour',
      revenue: '291.01',
      sales: '88',
      salesUp: true
    },
    {
      img: require('@src/assets/images/icons/book.svg').default,
      name: 'Cafés',
      email: 'pudais@jife.com',
      icon: <Coffee size={18} />,
      category: 'Grocery',
      views: '208',
      time: '1 week',
      revenue: '783.93',
      sales: '16'
    },
    {
      img: require('@src/assets/images/icons/rocket.svg').default,
      name: 'Kmart',
      email: 'bipri@cawiw.com',
      icon: <Watch size={18} />,
      category: 'Fashion',
      views: '990',
      time: '1 month',
      revenue: '780.05',
      sales: '78',
      salesUp: true
    },
    {
      img: require('@src/assets/images/icons/speaker.svg').default,
      name: 'Payers',
      email: 'luk@izug.io',
      icon: <Watch size={18} />,
      category: 'Fashion',
      views: '12.9k',
      time: '12 hours',
      revenue: '531.49',
      sales: '42',
      salesUp: true
    }
  ]
  const colorsArr = {
    Technology: 'light-primary',
    Grocery: 'light-success',
    Fashion: 'light-warning'
  }

  const renderData = () => {
    return data.map(col => {
      const IconTag = col.salesUp ? (
         
        <TrendingUp size={15} className='text-success' />
      ) : (
        <TrendingDown size={15} className='text-danger' />
      )

      return (
        <tr key={col.name}>
          <td>
            <div className='d-flex align-items-center'>
              <div className='avatar rounded'>
                <div className='avatar-content'>
                  <img  className='img_small_logo' 
                  style={{borderRadius:10}}
                  src={col.logo ? col.logo : require('@src/assets/images/restaurant.png').default } alt={col.name} />
                </div>
              </div>
              <div>
                <div className='fw-bolder'>{col.name}</div>
                <div className='font-small-2 text-muted'>{col.email}</div>
              </div>
            </div>
          </td>
          <td>
            <div className='d-flex align-items-center'>
              {/* <Avatar className='me-1' color={colorsArr[col.city]} icon={col.icon} /> */}
              <span>{col.city}</span>
            </div>
          </td>
          <td className='text-nowrap'>
            <div className='d-flex flex-column'>
              <span className='fw-bolder mb-25'>{col.orders}</span>
              <span className='font-small-2 text-muted'>in {col.time}</span>
            </div>
          </td>
          <td>${col.revenue}</td>
          <td>
            <div className='d-flex align-items-center'>
              <span className='fw-bolder me-1'>{col.sales}%</span>
              {IconTag}
            </div>
          </td>
        </tr>
      )
    })
  }

  return (
    <Card className='card-company-table'>
       
      <CardTitle style={{marginLeft:30, marginTop:20,}} tag='h4'>Top  Restaurant</CardTitle> 
      <Table responsive> 
        <thead>
          <tr>
            <th>Restaurant</th>
            <th>City</th>
            <th>Orders</th>
            <th>Revenue</th>
            <th>Sales</th>
          </tr>
        </thead>
        <tbody>{renderData()}</tbody>
      </Table>
    </Card>
  )
}

export default CompanyTable
