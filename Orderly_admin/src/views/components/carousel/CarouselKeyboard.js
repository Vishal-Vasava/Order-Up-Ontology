// ** Reactstrap Imports
import { height } from "@mui/system";
import { UncontrolledCarousel } from "reactstrap";
import classes from "./abc.css"

const CarouselKeyboard = (props) => {
  const images = props.images.map((item, index) => {

    return {
      src: item.src,
      key: index,
      caption: "",
      altText: "Image",
      height: "100px",
    };
  });
  return (

    <UncontrolledCarousel

      items={images}
      height={200}
      keyboard={true}
      activeIndex={props.actIndex}
      next={props.next}
      previous={props.previous}
      className="h-50"
    />

  );
};
export default CarouselKeyboard;
