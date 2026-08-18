import React, { useState } from 'react'
import { Eye } from 'react-feather'
import AddMenuItem from '../../../views/store/menu-item/AddMenuItem'


const EditOrderStatus = (props) => {

    const [modal, setModal] = useState(false)

    const handleModal = () => setModal(!modal)


    return (
        <div>

           {props.length ? <a style={{color:"#007bff"}} onClick={handleModal}>{props.datas?.order_items?.length} </a>: <Eye style={{ cursor: "pointer" }} size={15} 
            onClick={handleModal}> </Eye>}
            {modal && <AddMenuItem allData={props.datas} open={modal} handleModal={handleModal} />}
        </div>
    )
}

export default EditOrderStatus