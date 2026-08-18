import React from "react";
import {
  Backdrop,
  Box,
  Fade,
  Modal,
  Checkbox,
  label,
  Button,
  FormControlLabel,
} from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import clsx from "clsx";
import { useEffect, useRef, useState } from "react";
import axios from "axios";
import "./SKu.css";
import { Close } from "@mui/icons-material";

const useStyles = makeStyles((theme) => ({
  container: {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    width: "auto",
    backgroundColor: theme.palette.background.paper,
    border: "2px solid #555",
    padding: "1rem",
  },
  choices: {
    maxHeight: "60vh",
    overflowY: "scroll",
  },
  checkBox: {
    marginBottom: "10px",
    width: "30%",
    justifyContent: "flex-start",
    alignItems: "flex-start",
    "& span": {
      display: "flex",
      alignItems: "center",
      paddingTop: "0",
      "&:last-child": {
        top: "-10px",
        width: "100%",
        alignItems: "flex-start",
        height: "40px",
        overflow: "hidden",
        display: "-webkit-box",
        "-webkit-line-clamp": "2",
        "-webkit-box-orient": "vertical",
      },
    },
  },
  gallery: {
    margin: "5px",
    border: "1px solid #ccc",
    float: "left",
    width: "180px",
  },

  gallery: {
    border: "1px solid #777",
  },

  gallery: {
    width: "100%",
    height: "auto",
  },

  desc: {
    padding: "15px",
    textAlign: "center",
  },
}));
const ShowSKUGallery = ({
  openModal,
  setOpenModal,
  setlogoImage,
  setImageId,
  setInputValue,
  inputValue,
}) => {
  const token = localStorage.getItem("token");

  const classes = useStyles();
  const handleClose = () => setOpenModal(false);
  const [skyImages, setSkuImages] = useState([]);

  const getSkuImages = () => {
    axios
      .get("/admin/gallery", { headers: { Authorization: `Bearer ${token}` } })
      .then((response) => {
        setSkuImages(response.data.data);
      })
      .catch((err) => {
        console.log(err);
        ``;
      });
  };
  useEffect(() => {
    getSkuImages();
  }, []);

  return (
    <Modal
      open={openModal}
      onClose={handleClose}
      closeAfterTransition
      BackdropComponent={Backdrop}
      BackdropProps={{
        timeout: 200,
        onDragOver: (e) => e.preventDefault(),
        onDrop: (e) => e.preventDefault(),
      }}
    >
      <Fade in={openModal}>
        <Box
          className={clsx(classes.container, "rounded-12")}
          style={{ width: "57%", height: "50%", overflow: "scroll" }}
        >
          <div>
            <div
              style={{ textAlign: "end" }}
              onClick={() => setOpenModal(false)}
            >
              <Close style={{ cursor: "pointer" }} />
            </div>
            <div>
              {skyImages?.map((i) => {
                return (
                  <div
                    class="gallery"
                    style={{ width: "100px" }}
                    onClick={() => {
                      setlogoImage(i.image_url);
                      setImageId(i._id);
                      setOpenModal(false);
                      setInputValue({
                        ...inputValue,
                        desc: i.description,
                        productName: i.title,
                      });
                    }}
                  >
                    <img
                      src={i.image_url}
                      alt="Cinque Terre"
                      style={{ height: "100px" }}
                    />

                    {/* <div class="desc">Add a description of the image here</div> */}
                  </div>
                );
              })}
            </div>
          </div>
        </Box>
      </Fade>
    </Modal>
  );
};

export default ShowSKUGallery;
