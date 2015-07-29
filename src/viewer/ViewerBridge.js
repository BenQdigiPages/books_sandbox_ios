//***************************************************************************
//* Written by Steve Chiu <steve.chiu@benq.com>
//* BenQ Corporation, All Rights Reserved.
//*
//* NOTICE: All information contained herein is, and remains the property
//* of BenQ Corporation and its suppliers, if any. Dissemination of this
//* information or reproduction of this material is strictly forbidden
//* unless prior written permission is obtained from BenQ Corporation.
//***************************************************************************

// This is iOS only glue, Android can export functions natively

var App = {}

App.callback = function(name, args) {
    var iframe = document.createElement('iframe');
    var json = JSON.stringify(args).replace(/%/g, '%25').replace(/#/g, '%23');
    iframe.setAttribute('src', 'app://' + name + '?' + json);
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
}

///
/// Notify App current title is changed
///
/// @title: string - title to be shown on toolbar
///
App.onChangeTitle = function(title) {
    this.callback("onChangeTitle", [title]);
}

///
/// Notify App current table of content is changed
///
/// @[toc_entry, ...]: array - an json array to the TOC entry
///
App.onChangeTOC = function(toc_entry_array) {
    this.callback("onChangeTOC", [toc_entry_array]);
}

///
/// Notify App current view frame is changed
/// This is needed for PDF annotation
/// Content offset is the relative position (after scaling) to the top-left corner.
/// Content offset (x: -10, y: -20) will make top edge 20 pixels off-screen,
/// left edge 10 pixels off-screen
///
/// @offset_x: number - content offset x
/// @offset_y: number - content offset y
/// @scale: number - scale of content view, 1.0 is original size
///
App.onChangeView = function(offset_x, offset_y, scale) {
    this.callback("onChangeView", [offset_x, offset_y, scale]);
}

///
/// Notify App current page is changed to different page
///
/// @chapter: string - an opaque to represent current chapter
/// @cfi: string - epub cfi
/// @current_page: int - page number of current page
/// @total_pages: int - total number of pages
///
App.onChangePage = function(chapter, cfi, current_page, total_pages) {
    this.callback("onChangePage", [chapter, cfi, current_page, total_pages]);
}

///
/// Notify App user action for tracking
///
/// @action: string - tracking "action" as defined in doc
/// @cfi: string - tracking "cfi" as defined in doc, may be empty for some action
///
App.onTrackAction = function(action, cfi) {
    this.callback("onTrackAction", [action, cfi]);
}

///
/// Notify App to show or hide toolbar
///
/// @visible: bool - set visibility of tool bar
///
App.onToggleToolbar = function(visible) {
    this.callback("onToggleToolbar", [visible]);
}

///
/// Request App to load highlights for the chapter, App will call callback in response
/// The callback will receive an array of json object to represent highlights
///
///     function callback([highlight, ...])
///
/// @chapter: string - an opaque to represent current chapter
/// @callback: string - name of callback function (can be object member function)
///     do not pass function itself, only name (as string) is needed;
///     and the function must be accessable from global space
///
App.onRequestHighlights = function(chapter, callback) {
    this.callback("onRequestHighlights", [chapter, callback]);
}

///
/// Notify App the given highlight need to be added, App will call callback in response
/// The callback will receive the UUID of new highlight just created
///
///     function callback(uuid)
///
/// @chapter: string - an opaque to represent current chapter
/// @highlight - an json object to represent highlight, uuid is absent in this case
/// @callback: string - name of callback function (can be object member function);
///     do not pass function itself, only name (as string) is needed;
///     and the function must be accessable from global space
///
App.onAddHighlight = function(chapter, highlight, callback) {
    this.callback("onAddHighlight", [chapter, highlight, callback]);
}

///
/// Notify App the given highlight need to be updated
///
/// @highlight - an json object to represent highlight
///
App.onUpdateHighlight = function(highlight) {
    this.callback("onUpdateHighlight", [highlight]);
}

///
/// Notify App the given highlight need to be deleted
///
/// @uuid - uuid of the highlight
///
App.onRemoveHighlight = function(uuid) {
    this.callback("onRemoveHighlight", [uuid]);
}

///
/// Notify App the given highlight need to be shared, App will popup sharing dialog
///
/// @uuid - uuid of the highlight
///
App.onShareHighlight = function(uuid) {
    this.callback("onShareHighlight", [uuid]);
}

///
/// Notify App the given highlight need to be annotated, App will popup edit window
///
/// @uuid - uuid of the highlight
///
App.onAnnotateHighlight = function(uuid) {
    this.callback("onAnnotateHighlight", [uuid]);
}

///
/// Request App to load bookmark for the chapter, App will call callback in response
/// The callback will receive an array of json object to represent bookmarks
///
///     function callback([bookmark, ...])
///
/// @chapter: string - an opaque to represent current chapter
/// @callback: string - name of callback function (can be object member function);
///     do not pass function itself, only name (as string) is needed;
///     and the function must be accessable from global space
///
App.onRequestBookmarks = function(chapter, callback) {
    this.callback("onRequestBookmarks", [chapter, callback]);
}

///
/// Notify App the given bookmark need to be added, App will call callback in response
/// The callback will receive the UUID of new bookmark just created
///
///     function callback(uuid)
///
/// @chapter: string - an opaque to represent current chapter
/// @bookmark - an json object to represent bookmark, uuid is absent in this case
/// @callback: string - name of callback function (can be object member function);
///     do not pass function itself, only name (as string) is needed;
///     and the function must be accessable from global space
///
App.onAddBookmark = function(chapter, bookmark, callback) {
    this.callback("onAddBookmark", [chapter, bookmark, callback]);
}

///
/// Notify App the given bookmark need to be updated
///
/// @bookmark - an json object to represent bookmark
///
App.onUpdateBookmark = function(bookmark) {
    this.callback("onUpdateBookmark", [bookmark]);
}

///
/// Notify App the given bookmark need to be deleted
///
/// @uuid - uuid of the bookmark
///
App.onRemoveBookmark = function(uuid) {
    this.callback("onRemoveBookmark", [uuid]);
}

///
/// Notify App the search result is found
/// View can call this multiple times until App call Viewer.searchText(null)
///
/// @keyword - the search keyword
/// @result - an json object to represent search result
///
App.onSearchResult = function(keyword, result_array) {
    this.callback("onSearchResult", [keyword, result_array]);
}

/// For debug only
App.log = function(message) {
    this.callback("log", [message]);
}
