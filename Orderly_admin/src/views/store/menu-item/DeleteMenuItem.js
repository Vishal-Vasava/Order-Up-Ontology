import React, { useState } from 'react'
import { Trash } from 'react-feather'
import axios from 'axios'
import { useNavigate } from 'react-router-dom'
import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap'


const DeleteMenuItem = (props) => {

    const [modal, setModal] = useState(null)

    const toggleModal = id => {
        console.log("menudeleteID1", id);
        if (modal !== id) {
            setModal(id)
        } else {
            setModal(null)
        }
    }
    const token = localStorage.getItem('token')
    const navigate = useNavigate()


    const deleteMenuItem = (delID) => {
        axios
            .post("/menuitem/delete", {
                id: delID

            }, { headers: { Authorization: `Bearer ${token}` } })
            .then((response) => {
                console.log("orderlisting", response)
                navigate(`${process.env.REACT_APP_FOLDER}/menu-item`)
            })
            .catch((err) => {
                console.log(err)
            })
    }
    return (
        <div>

            <div className="theme-modal-danger">
                <div style={{ marginRight: "5px" }}>
                    <Trash style={{ cursor: "pointer" }} size={15} onClick={() => toggleModal(props.menuDelete.id)} isOpen={open} />
                </div>

                <Modal
                    isOpen={modal === props.menuDelete.id}
                    toggle={() => toggleModal(props.menuDelete.id)}
                    className='modal-dialog-centered'
                    modalClassName="modal-danger"

                >
                    <ModalHeader toggle={() => toggleModal(props.menuDelete.id)}>Delete Item</ModalHeader>
                    <ModalBody>
                        Are you sure to delete this product?
                    </ModalBody>
                    <ModalFooter>
                        <Button color="danger" onClick={() => deleteMenuItem(props.menuDelete.id)}>
                            Delete
                        </Button>
                        <Button color="danger" onClick={() => setModal(null)}>
                            Cancel
                        </Button>
                    </ModalFooter>
                </Modal>
            </div>
        </div>

    )
}

export default DeleteMenuItem