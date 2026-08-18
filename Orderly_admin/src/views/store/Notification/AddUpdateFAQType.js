import React, { useState } from "react";
import { Edit, Eye } from "react-feather";
import AddUpdateModal from "./AddUpdateModal";

const UpdateActivity = (props) => {
  const [modal, setModal] = useState(false);

  const handleModal = () => setModal(!modal);

  return (
    <div>
      <Eye style={{ cursor: "pointer" }} size={15} onClick={handleModal}></Eye>
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
