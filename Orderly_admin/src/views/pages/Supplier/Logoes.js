import React from "react";
import { saveAs } from "file-saver";
import { Button, Card, Col, Row } from "reactstrap";
import logo1 from "../../../images/Logoes/GBC Logo ENG.png";
import logo2 from "../../../images/Logoes/GBC- Logo ENG.png";
import logo3 from "../../../images/Logoes/GBC- Logo JP.png";
import logo4 from "../../../images/Logoes/GBC- Logo JP (2).png";
import logo5 from "../../../images/Logoes/GBC- Sq Logo ENG.png";
import logo6 from "../../../images/Logoes/GBC- Sq Logo JP.png";

const imageArray = [
  {
    id: 1,
    imageUrl: logo1,
  },
  {
    id: 2,
    imageUrl: logo2,
  },
  {
    id: 3,
    imageUrl: logo3,
  },
  {
    id: 4,
    imageUrl: logo4,
  },
  {
    id: 5,
    imageUrl: logo5,
  },
  {
    id: 6,
    imageUrl: logo6,
  },
];

const Logoes = () => {
  const downloadImage = async (picture) => {
    const originalImage = picture;
    const image = await fetch(originalImage);

    //Split image name
    const nameSplit = originalImage.split("/");
    const duplicateName = nameSplit.pop();
    const imageBlog = await image.blob();
    const imageURL = URL.createObjectURL(imageBlog);
    const link = document.createElement("a");
    link.href = imageURL;
    link.download = "" + duplicateName + "";
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };
  return (
    <Row className="mb-1 mt-1">
      <Col xs={12} md={3}>
        <Card
          style={{
            height: "45vh",
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
          }}
        >
          <div>
            <Button color="primary">
              <a
                href="https://tourguideapp.s3.amazonaws.com/logos/image-1670222782317-245852362.zip"
                style={{ color: "white" }}
              >
                Download Zip
              </a>
            </Button>
          </div>
        </Card>
      </Col>

      {imageArray.map((i, index) => {
        return (
          <Col xs={12} md={3} key={index} className="mb-1">
            <Card>
              <div>
                <div>
                  <img
                    src={i.imageUrl}
                    style={{
                      width: "100%",
                      height: "35vh",
                      objectFit: "contain",
                    }}
                  />
                </div>
                <div
                  className="mt-1 mb-1"
                  style={{ display: "flex", justifyContent: "center" }}
                >
                  <Button
                    color="primary"
                    onClick={() => downloadImage(i.imageUrl)}
                  >
                    Download
                  </Button>
                </div>
              </div>
            </Card>
          </Col>
        );
      })}
    </Row>
  );
};

export default Logoes;
