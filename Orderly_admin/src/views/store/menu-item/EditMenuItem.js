import React, { useState } from 'react'
import { Eye } from 'react-feather'
import { useNavigate } from 'react-router-dom'
import EditMenuItemModal from './EditMenuItemModal'

const EditMenuItem = (props) => {
    const navigate = useNavigate();
    const [modal, setModal] = useState(false)

    const handleModal = (e) => {
        console.log("e.id", e);
        navigate(`${process.env.REACT_APP_FOLDER}/pages/account-settings`, {
            state: {
                tour: props.MenuItem
            }
        });
    }

    return (
        <div>

            <Eye style={{ cursor: "pointer" }} size={15} onClick={() => handleModal(props.MenuItem.id)}>123</Eye>
            {/* {modal && <EditMenuItemModal menuItem={props.MenuItem} open={modal} handleModal={handleModal} />} */}
        </div>
    )
}


export default EditMenuItem