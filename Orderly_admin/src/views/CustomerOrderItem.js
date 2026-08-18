import React, { useState } from 'react'
import { Eye } from 'react-feather'



import CustomerOrderItemModal from '../views/superadmin/CustomerOrderItemModal'


const CustomerOrderItem = (props) => {

    const [modal, setModal] = useState(false)

    const handleModal = () => setModal(!modal)

    console.log("orderItems", props.data);


    return (
        <div>

            <Eye style={{ cursor: "pointer" }} size={15} onClick={handleModal}>123 </Eye>
            {modal && <CustomerOrderItemModal data={props.data} open={modal} handleModal={handleModal} />}
        </div>
    )
}

export default CustomerOrderItem