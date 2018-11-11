import React, { Component } from "react";
import "./Home.css";
import {PageHeader, ListGroup, ListGroupItem} from "react-bootstrap";
import { API } from "aws-amplify";
import { LinkContainer } from "react-router-bootstrap";
import {Link} from "react-router-dom";

export default class Home extends Component {
    constructor(props) {
        super(props);

        this.state = {
            isLoading: true,
            notes: []
        };
    }

    async componentDidMount() {
        if (!this.props.isAuthenticated) {
            return;
        }

        try {
            const notes = await this.notes();
            this.setState({ notes });
        } catch (e) {
            alert(e);
        }

        this.setState({ isLoading: false });
    }

    notes() {
        return API.get("notes", "/notes", []);
    }

    renderNotesList(notes) {
        // Prepend an empty object at the start of the array to add a "Create a note" button even if the array is empty
        return [{}].concat(notes).map(
            (note, i) =>
                i !== 0
                    ? <LinkContainer
                        key={note.noteId}
                        to={`/notes/${note.noteId}`}
                    >
                        <ListGroupItem header={note.content.trim().split("\n")[0]}>
                            {"Created: " + new Date(note.createdAt).toLocaleString()}
                        </ListGroupItem>
                    </LinkContainer>
                    : <LinkContainer
                        key="new"
                        to="/notes/new"
                    >
                        <ListGroupItem>
                            <h4>
                                <b>{"\uFF0B"}</b> Create a new note
                            </h4>
                        </ListGroupItem>
                    </LinkContainer>
        );
    }

    renderLander() {
        return (
            <div className="Home">
                <div className="lander">
                    <h1>Scratch</h1>
                    <p>A simple note taking app</p>
                    <div>
                        <Link to="/login" className="btn btn-info btn-lg">
                            Login
                        </Link>
                        <Link to="/signup" className="btn btn-success btn-lg">
                            Signup
                        </Link>
                    </div>
                </div>
            </div>
        );
    }

    renderNotes() {
        return (
            <div className="notes">
                <PageHeader>Your notes</PageHeader>
                <ListGroup>
                    {!this.state.isLoading && this.renderNotesList(this.state.notes)}
                </ListGroup>
            </div>
        );
    }

    render() {
        return (
            <div className="Home">
                {this.props.isAuthenticated ? this.renderNotes(): this.renderLander()}
            </div>
        );
    }
}