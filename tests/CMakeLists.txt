if(NOT ALLEGRO_LINK_WITH OR NOT ALLEGRO_MAIN_LINK_WITH OR
        NOT IMAGE_LINK_WITH OR NOT COLOR_LINK_WITH OR
        NOT FONT_LINK_WITH OR NOT TTF_LINK_WITH)
    return()
endif()

include_directories(
    ../addons/acodec
    ../addons/audio
    ../addons/color
    ../addons/font
    ../addons/image
    ../addons/main
    ../addons/memfile
    ../addons/native_dialog
    ../addons/physfs
    ../addons/primitives
    ../addons/ttf
    )

add_our_executable(
    test_driver
    ${ALLEGRO_LINK_WITH}
    ${ALLEGRO_MAIN_LINK_WITH}
    ${IMAGE_LINK_WITH}
    ${COLOR_LINK_WITH}
    ${FONT_LINK_WITH}
    ${TTF_LINK_WITH}
    )

add_custom_target(test_bitmaps
    DEPENDS test_driver
    COMMAND test_driver ${CMAKE_CURRENT_SOURCE_DIR}/test_bitmaps.ini
    )

add_custom_target(test_locking
    DEPENDS test_driver
    COMMAND test_driver ${CMAKE_CURRENT_SOURCE_DIR}/test_locking.ini
    )

add_custom_target(test_locking2
    DEPENDS test_driver
    COMMAND test_driver ${CMAKE_CURRENT_SOURCE_DIR}/test_locking2.ini
    )

add_custom_target(test_image
    DEPENDS test_driver
    COMMAND test_driver ${CMAKE_CURRENT_SOURCE_DIR}/test_image.ini
    )

add_custom_target(test_fonts
    DEPENDS test_driver
    COMMAND test_driver ${CMAKE_CURRENT_SOURCE_DIR}/test_fonts.ini
    )

# vim: set sts=4 sw=4 et: