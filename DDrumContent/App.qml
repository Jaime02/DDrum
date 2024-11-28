// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import DDrum

Window {
    id: root

    width: Constants.width
    height: Constants.height

    visible: true
    title: "DDrum"

    MainScreen {
        id: mainScreen
        anchors.centerIn: parent
    }
}

