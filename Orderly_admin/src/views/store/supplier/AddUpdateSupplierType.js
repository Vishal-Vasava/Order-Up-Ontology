import React, { useState } from "react";
import { Edit, Eye, ShoppingBag } from "react-feather";
import AddUpdateModal from "./AddUpdateModal";
import { useNavigate } from "react-router-dom";

const UpdateActivity = (props) => {
  const [modal, setModal] = useState(false);
  const navigate = useNavigate()

  const handleModal = () => setModal(!modal);
  console.log("sacaaca", props);

  return (
    <div>
      <Eye style={{ cursor: "pointer" }} size={15} onClick={handleModal}>
         
      </Eye>
      <ShoppingBag style={{ cursor: "pointer", marginLeft:"20px" }} size={15} onClick={() => {
      navigate(`/admin/view-orders/${props?.MenuItem?._id}`)
      }}>
         
      </ShoppingBag>
      {modal && (
        <AddUpdateModal
          activity={props.MenuItem}
          open={modal}
          handleModal={handleModal}
          setModal={setModal}
        />
      )}
    </div>
  );
};

export default UpdateActivity;
