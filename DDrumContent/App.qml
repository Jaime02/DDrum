// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import DDrum

Window {
    id: root

    height: 800
    title: "DDrum"
    visible: true
    width: 1200

    MainScreen {
        id: mainScreen

        anchors.fill: parent
    }
}
