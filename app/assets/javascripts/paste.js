var Paste = (function() {
    var SWF = "swf";
    var IMAGE = "image";
    var CODE = "code";
    
    var FADED_OPACITY = 0.2;
    var MAX_SWF_SIZE = 20 * 1024 * 1024;
    var MAX_IMAGE_SIZE = 2 * 1024 * 1024;
    
    var module = {};
    var fileType = null;
    var clickedFileType = null;
    var submitted = false;
    
    function getFile() {
        var input = $("#input-file");
        var fileList = input[0].files;
        if (fileList.length == 0) {
            return null;
        }
        return fileList[0];
    }
    
    function chooseFile(type) {
        if (fileType != null || submitted) {
            return;
        }
        clickedFileType = type;
        $("#input-file").click();
        $("#input-type").val(clickedFileType);
    }
    
    function onFileChange() {
        var file = getFile();
        if (file == null || submitted) {
            cancel();
            return;
        }
        fileType = clickedFileType;
        
        if (!validateFile(file.name, clickedFileType)) {
            cancel();
            module.error("File '" + file.name + "' is not a valid " + clickedFileType + " file!");
            return;
        } else if (!validateFileSize(file.size, clickedFileType)) {
            cancel();
            module.error("File is too large");
            return;
        }
        
        var box = getUploadBox(fileType);
        box.find(".hidden").show(500);
        box.find(".filesize").text(addCommas(file.size) + " bytes");
        box.find(".name").text(file.name);
        $("#code").prop("disabled", true);
        
        if (!$("#input-title").data("touched") || $("#input-title").val() == "") {
            $("#input-title").val(file.name);
        }
        
        hideOthers();
        updateSubmitButton();
    }
    
    function validateFile(file, type) {
        var extension = getFileExtension(file);
        if ((type == SWF && extension != "swf") || (type == IMAGE && (extension != "jpg" && extension != "jpeg" && extension != "png" && extension != "gif"))) {
            return false;
        }
        return true;
    }
    
    function validateFileSize(size, type) {
        if ((type == SWF && size > MAX_SWF_SIZE) || (type == IMAGE && size > MAX_IMAGE_SIZE)) {
            return false;
        }
        return true;
    }
    
    function getFileExtension(filename) {
        return (filename.split(".").pop() || "").toLowerCase();
    }
    
    function updateSubmitButton() {
        $("#input-submit").prop("disabled", fileType == null).find("span").text("Upload" + (fileType == null ? "" : " " + getReadableType(fileType)));
    }
    
    function onCodeChange() {
        if (submitted) {
            return;
        }
        
        var box = getUploadBox(fileType);
        if (fileType != CODE) {
            fileType = CODE;
            $("#input-type").val(fileType);
            box.find(".hidden").stop(true, true).show(500);
            hideOthers();
            updateSubmitButton();
        } else if (fileType == CODE && $("#code").val() == "") {
            cancelInput();
        }
    }
    
    function hideOthers() {
        if (fileType != IMAGE) {
            $("#upload-img").stop(true, true).animate({ opacity : FADED_OPACITY }, 500);
        }
        if (fileType != SWF) {
            $("#upload-swf").stop(true, true).animate({ opacity : FADED_OPACITY }, 500);
        }
        if (fileType != CODE) {
            $("#upload-code").stop(true, true).animate({ opacity : FADED_OPACITY }, 500);
        }
        $("#error").hide(250).find(".content").text("");
    }
    
    function cancelInput() {
        if (submitted) {
            return;
        }
        
        if (fileType == CODE) {
            cancelCode();
        } else {
            cancelFile();
        }
        if (!$("#input-title").data("touched")) {
            $("#input-title").val("");
        }
        $("#error").hide().find(".content").text("");
        cancel();
    }
    
    function cancelCode() {
        if (fileType != CODE) {
            return;
        }
        $("#code").val("");
    }
    
    function cancel() {
        if (submitted) {
            return;
        }
        
        fileType = null;
        $(".hidden").stop(true, true).hide(500);
        $("#upload-img, #upload-swf, #upload-code").stop(true, true).animate({ opacity : 1 }, 500);
        updateSubmitButton();
        $("#code").prop("disabled", false);
    }
    
    function cancelFile() {
        if (fileType == null) {
            return;
        }
        var name = getUploadBox(fileType).find(".name");
        name.text(name.data("content"));
        $("#input-file").wrap("<form>").closest("form").get(0).reset();
        $("#input-file").unwrap();
    }
    
    function getUploadBox(type) {
        return $("#" + (type == IMAGE ? "upload-img" : type == SWF ? "upload-swf" : "upload-code"));
    }
    
    function addCommas(number) {
        number += "";
        var rgx = /(\d+)(\d{3})/;
        while (rgx.test(number)) {
            number = number.replace(rgx, '$1' + ',' + '$2');
        }
        return number;
    }
    
    function getReadableType(type) {
        switch (type) {
            case SWF: return "SWF"; break;
            case IMAGE: return "Image"; break;
            case CODE: return "Code"; break;
        }
        return null;
    }
    
    function submitForm(ev) {
        $("#input-submit").prop("disabled", true);
        $("#input-submit span").html("<i class='icon-spinner icon-spin'></i>");
        submitted = true;
    }
    
    module.error = function(message) {
        $("#error").stop(true, true).hide(250, function() {
            $("#error .content").text(message);
            $("#error").show(500);
        });
    };
    
    module.initialize = function() {
        if ($("#paste").length < 1) {
            return;
        }
        
        $("#file-swf").click(function() {
            chooseFile(SWF);
        });
        
        $("#file-img").click(function() {
            chooseFile(IMAGE);
        });
        
        $(".cancel").click(cancelInput);
        
        $("#input-file").change(onFileChange);
        $("#code").on("keyup change paste", onCodeChange);
        $("#input-title").data("touched", false);
        $("#input-title").on("change", function() { $("#input-title").data("touched", true); });
        $("form").submit(submitForm);
    };
    
    return module;
})();


$(Paste.initialize);
