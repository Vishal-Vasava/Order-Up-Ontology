import React, { useState, useEffect } from "react";
import { Button, Col, Input, Label, Row } from "reactstrap";

const Textfields = (props) => {
  const [value, setValue] = useState({
    id: "",
    value: "",
  });
  useEffect(() => { }, props);
  const handleTranslate = (myval) => {
    props.ENtoKOJP(myval);
  };
  console.log("value", value);
  return (
    <>
      <Col sm={props.id === 1 ? 10 : 12} className=" mt-1">
        <Label className="form-label" for="tripname">
          {props.title}
        </Label>
        <Input
          id={props.id}
          Label="ass"
          name={props.name}
          placeholder={props.placeholder}
          value={props.value}
          onChange={(e) => {
            setValue({ id: props.id, value: e.target.value });
            const edit = props.titles.map((i) => {
              console.log("props.titles", i.titles);
              if (i.id === props.id) {
                return {
                  id: i.id,
                  lang: i.lang,
                  name: i.name,
                  placeholder: i.placeholder,
                  titles: i.titles,
                  value: e.target.value,
                };
              } else {
                return {
                  id: i.id,
                  lang: i.lang,
                  name: i.name,
                  titles: i.titles,
                  placeholder: i.placeholder,
                  value: i.value,
                };
              }
            });
            console.log("edit", edit);
            // props.setTitles(e.target.value)

            props.setTitles(edit);
          }}
        />
      </Col>
      {props.id === 1 && (
        <Col sm="2" style={{ marginTop: "2.6rem" }}>
          <Button
            type="submit"
            color="primary"
            onClick={() => handleTranslate(props.value)}
          >
            Translate
          </Button>
        </Col>
      )}
    </>
  );
};

export default Textfields;
