import moment from "moment/moment";
export const customDataBodyRender = (
  value,
  tableMeta = undefined,
  updateValue = undefined
) => {
  if (
    value === undefined ||
    value === null ||
    value === "null" ||
    value === "nil" ||
    value === ""
  )
    return null;
  return value;
};

export const convertArrayOfObjects2CSV = (array) => {
  let result;

  const columnDelimiter = ",";
  const lineDelimiter = "\n";
  const keys = Object.keys(array[0]);

  result = "";
  result += keys.join(columnDelimiter);
  result += lineDelimiter;

  array.forEach((item) => {
    let ctr = 0;
    keys.forEach((key) => {
      if (ctr > 0) result += columnDelimiter;

      result += item[key];

      ctr++;
    });
    result += lineDelimiter;
  });

  return result;
};

// formatPhoneNumber1(row.country_code ,row.phone_number)
export const formatPhoneNumber1 = (countryCode1, phone1) => {
  let countryCode = countryCode1 + "";
  let phone = phone1 + "";

  // if input value is falsy eg if the user deletes the input, then just return

  if (countryCode.toString().startsWith("1")) {
    let value = countryCode + phone;
    if (!value) return value;
    // clean the input for any non-digit values.
    const phoneNumber = value.replace(/[^\d]/g, "");
    // phoneNumberLength is used to know when to apply our formatting for the phone number
    const phoneNumberLength = phoneNumber.length;
    // we need to return the value with no formatting if its less then four digits
    // this is to avoid weird behavior that occurs if you  format the area code to early

    if (phoneNumberLength < 4) return phoneNumber;

    // if phoneNumberLength is greater than 4 and less the 7 we start to return
    // the formatted number
    if (phoneNumberLength < 7) {
      return `${phoneNumber.substring(0, 1)} (${phoneNumber.substring(
        1,
        4
      )}) ${phoneNumber.substring(4, 7)}`;
    }
    // return phoneNumber + `(${phoneNumber.slice(0, 3)}) ${phoneNumber.slice(3)}`;

    // finally, if the phoneNumberLength is greater then seven, we add the last
    // bit of formatting and return it.
    return `${phoneNumber.substring(0, 1)} (${phoneNumber.substring(
      1,
      4
    )}) ${phoneNumber.substring(4, 7)}-${phoneNumber.substring(7)}`;
  } else {
    //non us number

    if (!phone) return phone;

    // clean the input for any non-digit values.
    const phoneNumber = phone.replace(/[^\d]/g, "");

    // phoneNumberLength is used to know when to apply our formatting for the phone number
    const phoneNumberLength = phoneNumber.length;

    // we need to return the value with no formatting if its less then four digits
    // this is to avoid weird behavior that occurs if you  format the area code to early

    if (phoneNumberLength < 4) return `${countryCode} ${phoneNumber}`;

    // if phoneNumberLength is greater than 4 and less the 7 we start to return
    // the formatted number
    if (phoneNumberLength < 7) {
      return `${countryCode} (${phoneNumber.slice(0, 3)}) ${phoneNumber.slice(
        3
      )}`;
    }

    // finally, if the phoneNumberLength is greater then seven, we add the last
    // bit of formatting and return it.
    return `${countryCode} (${phoneNumber.slice(0, 3)}) ${phoneNumber.slice(
      3,
      6
    )}-${phoneNumber.slice(6)}`;
  }
};

export const formatePhoneForPhoneInput = (phone) => {
  //non us number

  if (!phone) return phone;

  // clean the input for any non-digit values.
  const phoneNumber = phone.replace(/[^\d]/g, "");

  // phoneNumberLength is used to know when to apply our formatting for the phone number
  const phoneNumberLength = phoneNumber.length;

  // we need to return the value with no formatting if its less then four digits
  // this is to avoid weird behavior that occurs if you  format the area code to early

  if (phoneNumberLength < 3) return `${phoneNumber}`;

  // if phoneNumberLength is greater than 4 and less the 7 we start to return
  // the formatted number
  if (phoneNumberLength < 7) {
    return `(${phoneNumber.slice(0, 3)}) ${phoneNumber.slice(3)}`;
  }

  // finally, if the phoneNumberLength is greater then seven, we add the last
  // bit of formatting and return it.
  return `${phoneNumber.slice(0, 3)} ${phoneNumber.slice(
    3,
    7
  )}-${phoneNumber.slice(7)}`;
};
