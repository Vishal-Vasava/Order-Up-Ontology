import React from "react";
import PropTypes from "prop-types";
import DropzoneComponent from "react-dropzone-component";

const componentConfig = {
    iconFiletypes: [".jpg", ".png", ".gif", ".mp3"],
    showFiletypeIcon: true,
    postUrl: "https://honeysuckle-snowstorm.glitch.me/uploadHandler"
};

const djsConfig = {
    addRemoveLinks: true
};

class DropUploader extends React.Component {
    static propTypes = {
        initialMedia: PropTypes.array,
        onUpload: PropTypes.function,
        onRemove: PropTypes.function
    };

    static defaultProps = {
        initialMedia: [],
        onUpload: () => { },
        onRemove: () => { }
    };

    state = {
        media: []
    };

    componentDidMount() {
        // Check initialMedia if there is any copy from props to state
        const { initialMedia } = this.props;
        if (initialMedia.length > 0) {
            this.setState({ media: initialMedia });
        }
    }

    render() {
        console.log("state media", this.props.onUpload);

        return (
            <DropzoneComponent
                config={componentConfig}
                eventHandlers={{
                    success: (file) => {
                        // Get server response

                        const res = JSON.parse(file.xhr.responseText);
                        let { media } = this.state;
                        media = [...media, res.data];
                        this.setState({ media }, () => this.props.onUpload(res.data));
                    },
                    removedfile: (file) => {
                        let { media } = this.state;
                        if (media.length > 0) {
                            // TODO: get current removed media from file
                            const removedMedia = this.state.media[0];
                            media = media.filter((m) => m.id !== removedMedia.id);
                            this.setState({ media }, () => this.props.onRemove(removedMedia));
                        }
                    }
                }}
                djsConfig={djsConfig}
            />
        );
    }
}

export default DropUploader;
