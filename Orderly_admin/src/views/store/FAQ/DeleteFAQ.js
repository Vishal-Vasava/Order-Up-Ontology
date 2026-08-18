import React from "react";
import { useState } from "react";
import { Button, Col, Modal, ModalBody, ModalHeader, Row } from "reactstrap";

const DeleteFAQ = (props) => {
  const [show, setShow] = useState(true);
  const token = localStorage.getItem("token");

  console.log("status: 123", show);

  const handelDelete = async () => {
    // await axios({
    //   method: "delete",
    //   url: `admin/faq/delete/${props._id}`,
    //   headers: {
    //     // "content-type": "application/json",
    //     Authorization: `Bearer ${token}`,
    //   },
    //   data: inputValues,
    // })
    //   .then((response) => {
    //     handleModal();
    //     navigate(`${process.env.REACT_APP_FOLDER}/faq-listing`);
    //     // setModal(false)
    //     toast.success("Successfully updated.");
    //   })
    //   .catch((err) => {
    //     console.log(err);
    //     toast.error(
    //       err.response.data.message
    //         ? err.response.data.message
    //         : "Something wrong"
    //     );
    //   });
  };

  return (
    <div>
      <Modal
        isOpen={show}
        toggle={() => setShow(!show)}
        className="modal-dialog-centered"
        onClosed={() => {
          setShow(false);
        }}
      >
        <ModalHeader
          className="bg-transparent"
          toggle={() => setShow(!show)}
        ></ModalHeader>
        <ModalBody className="px-sm-5 mx-50 pb-5">
          <h4 className="text-center mb-1">Are you sure to delete FQA?</h4>
          <Row tag="form" className="gy-1 gx-2 mt-75">
            <Col className="text-center mt-1" xs={12}>
              <Button className="me-1" color="primary" onClick={handelDelete}>
                Submit
              </Button>
              <Button
                color="secondary"
                outline
                onClick={() => {
                  setShow(!show);
                  // reset();
                }}
              >
                Cancel
              </Button>
            </Col>
          </Row>
        </ModalBody>
      </Modal>
    </div>
  );
};

export default DeleteFAQ;
